#!/usr/bin/env bash
# Renders: [Opus] ▓▓▓▓░░░░░░ 38% | 16.7k tok | 12m
# Max plan is flat-rate, so cost.total_cost_usd is meaningless — show token count instead.
input=$(cat)

MODEL=$(jq -r '.model.display_name // "?"' <<<"$input")
PCT=$(jq -r '(.context_window.used_percentage // 0) | floor' <<<"$input")
IN_TOK=$(jq -r '.context_window.total_input_tokens // 0' <<<"$input")
OUT_TOK=$(jq -r '.context_window.total_output_tokens // 0' <<<"$input")
DUR_MS=$(jq -r '.cost.total_duration_ms // 0' <<<"$input")

FILLED=$((PCT * 10 / 100))
[ "$FILLED" -gt 10 ] && FILLED=10
EMPTY=$((10 - FILLED))
BAR=""
for ((i=0; i<FILLED; i++)); do BAR+="▓"; done
for ((i=0; i<EMPTY;  i++)); do BAR+="░"; done

TOTAL_TOK=$((IN_TOK + OUT_TOK))
if [ "$TOTAL_TOK" -ge 1000 ]; then
  WHOLE=$((TOTAL_TOK / 1000))
  TENTH=$(( (TOTAL_TOK % 1000) / 100 ))
  TOK_FMT="${WHOLE}.${TENTH}k tok"
else
  TOK_FMT="${TOTAL_TOK} tok"
fi

MINS=$((DUR_MS / 60000))

printf '[%s] %s %d%% | %s | %dm' "$MODEL" "$BAR" "$PCT" "$TOK_FMT" "$MINS"
