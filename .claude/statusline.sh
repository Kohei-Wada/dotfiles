#!/usr/bin/env bash
# Renders: [Opus] cmp ━━━●──────── ctx ━●────────── | 17.0k tok | 12m
# cmp bar = progress toward auto-compaction. ctx bar = full context window usage.
input=$(cat)

MODEL=$(jq -r '.model.display_name // "?"' <<<"$input")
PCT=$(jq -r '(.context_window.used_percentage // 0) | floor' <<<"$input")
IN_TOK=$(jq -r '.context_window.total_input_tokens // 0' <<<"$input")
OUT_TOK=$(jq -r '.context_window.total_output_tokens // 0' <<<"$input")
DUR_MS=$(jq -r '.cost.total_duration_ms // 0' <<<"$input")

# Auto-compact threshold is undocumented; 85% matches observed behavior.
COMPACT_AT=85
WIDTH=12

render_bar() {
  local pos=$1 i out=""
  [ "$pos" -ge "$WIDTH" ] && pos=$((WIDTH - 1))
  for ((i=0; i<WIDTH; i++)); do
    if   [ "$i" -lt "$pos" ]; then out+="━"
    elif [ "$i" -eq "$pos" ]; then out+="●"
    else                           out+="─"
    fi
  done
  printf '%s' "$out"
}

BAR_CMP=$(render_bar $((PCT * WIDTH / COMPACT_AT)))
BAR_CTX=$(render_bar $((PCT * WIDTH / 100)))

if   [ "$PCT" -ge "$COMPACT_AT" ];        then WARN=" ⚠ COMPACT"
elif [ "$PCT" -ge $((COMPACT_AT - 10)) ]; then WARN=" ⚡ near"
else                                           WARN=""
fi

TOTAL_TOK=$((IN_TOK + OUT_TOK))
if [ "$TOTAL_TOK" -ge 1000 ]; then
  WHOLE=$((TOTAL_TOK / 1000))
  TENTH=$(( (TOTAL_TOK % 1000) / 100 ))
  TOK_FMT="${WHOLE}.${TENTH}k tok"
else
  TOK_FMT="${TOTAL_TOK} tok"
fi

MINS=$((DUR_MS / 60000))

PCT_CMP=$((PCT * 100 / COMPACT_AT))
[ "$PCT_CMP" -gt 100 ] && PCT_CMP=100

printf '[%s] cmp %s %d%%%s | ctx %s %d%% | %s | %dm' "$MODEL" "$BAR_CMP" "$PCT_CMP" "$WARN" "$BAR_CTX" "$PCT" "$TOK_FMT" "$MINS"
