#!/bin/bash

_log() {
    local level="$1"
    shift
    local color

    case "$level" in
        INFO) color="\033[34m";;
        OK)   color="\033[32m";;
        WARN) color="\033[33m";;
        ERROR) color="\033[31m";;
        *)    color="";;
    esac

    if [[ "$DEBUG_BASHRC" == "true" ]]; then
        printf "%b[%s]%b %s\n" "$color" "$level" "\033[0m" "$*" >&2
    fi
}

_log_info() { _log INFO "$@"; }
_log_ok()   { _log OK "$@"; }
_log_warn() { _log WARN "$@"; }
_log_error() { _log ERROR "$@"; }
