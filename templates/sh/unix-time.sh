#!/bin/bash

# Unix Time Conversion Functions

set -euo pipefail

# =============================================================================
# Unixtime → Various Formats
# =============================================================================

# YYYYMMDDHHMM
from_unix_yyyymmddhhmm() {
    date -d "@$1" "+%Y%m%d%H%M"
}

# YYYYMMDDHHMMSS
from_unix_yyyymmddhhmmss() {
    date -d "@$1" "+%Y%m%d%H%M%S"
}

# YYYY-MM-DD HH:MM:SS
from_unix_iso() {
    date -d "@$1" "+%Y-%m-%d %H:%M:%S"
}

# YYYY/MM/DD HH:MM
from_unix_slash() {
    date -d "@$1" "+%Y/%m/%d %H:%M"
}

# DD/MM/YYYY HH:MM
from_unix_ddmmyyyy() {
    date -d "@$1" "+%d/%m/%Y %H:%M"
}

# MM/DD/YYYY HH:MM
from_unix_mmddyyyy() {
    date -d "@$1" "+%m/%d/%Y %H:%M"
}

# YYYYMMDD
from_unix_yyyymmdd() {
    date -d "@$1" "+%Y%m%d"
}

# RFC2822
from_unix_rfc2822() {
    date -d "@$1" "+%a, %d %b %Y %H:%M:%S %z"
}

# 人間可読形式
from_unix_human() {
    date -d "@$1" "+%Y年%m月%d日 %H時%M分%S秒"
}

# カスタムフォーマット
from_unix_custom() {
    local unix_time="$1"
    local format="$2"
    date -d "@$unix_time" "+$format"
}

# =============================================================================
# Various Formats → Unixtime
# =============================================================================

# YYYYMMDDHHMM (202507121132)
to_unix_yyyymmddhhmm() {
    local d="$1"
    date -d "${d:0:4}-${d:4:2}-${d:6:2} ${d:8:2}:${d:10:2}:00" +%s
}

# YYYYMMDDHHMMSS (20250712113245)
to_unix_yyyymmddhhmmss() {
    local d="$1"
    date -d "${d:0:4}-${d:4:2}-${d:6:2} ${d:8:2}:${d:10:2}:${d:12:2}" +%s
}

# YYYY-MM-DD HH:MM:SS (2025-07-12 11:32:45)
to_unix_iso() {
    date -d "$1" +%s
}

# YYYY/MM/DD HH:MM (2025/07/12 11:32)
to_unix_slash() {
    date -d "$(echo "$1" | tr '/' '-')" +%s
}

# DD/MM/YYYY HH:MM (12/07/2025 11:32)
to_unix_ddmmyyyy() {
    local d="$1"
    local day="${d:0:2}"
    local month="${d:3:2}"
    local year="${d:6:4}"
    local time="${d:11}"
    date -d "$year-$month-$day $time:00" +%s
}

# MM/DD/YYYY HH:MM (07/12/2025 11:32)
to_unix_mmddyyyy() {
    local d="$1"
    local month="${d:0:2}"
    local day="${d:3:2}"
    local year="${d:6:4}"
    local time="${d:11}"
    date -d "$year-$month-$day $time:00" +%s
}

# YYYYMMDD (20250712)
to_unix_yyyymmdd() {
    local d="$1"
    date -d "${d:0:4}-${d:4:2}-${d:6:2} 00:00:00" +%s
}

# RFC2822 (Sat, 12 Jul 2025 11:32:45 +0900)
to_unix_rfc2822() {
    date -d "$1" +%s
}

# エポック秒文字列 ("1721619165")
to_unix_epoch_str() {
    echo "$1"
}

# =============================================================================
# Usage Examples (uncomment to test)
# =============================================================================

# unix_time=1721619165
# echo "ISO format: $(from_unix_iso $unix_time)"
# echo "Human readable: $(from_unix_human $unix_time)"
# echo "Custom format: $(from_unix_custom $unix_time "%Y-%m-%d %A")"

# echo "To unix: $(to_unix_iso "2025-07-12 11:32:45")"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}

error() {
    log "ERROR: $*"
    exit 1
}

main() {
    # This is a minimal shell script template.
    log "Starting the script..."
}

main "$@"

