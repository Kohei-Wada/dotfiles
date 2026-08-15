#!/bin/bash

_is_command_available() {
    local cmd="$1"
    command -v "$cmd" >/dev/null
}

_is_commands_available() {
    local cmd
    for cmd in "$@"; do
        if ! _is_command_available "$cmd"; then
            return 1
        fi
    done
    return 0
}

_file_exists() {
    local file="$1"
    [ -f "$file" ]
}

_directory_exists() {
    local dir="$1"
    [ -d "$dir" ]
}

# Prepend a directory to PATH only if it isn't already present.
# Idempotent: sourcing a config file twice will not duplicate entries.
addpath() {
    local dir="$1"
    [ -n "$dir" ] || return 0
    case ":$PATH:" in
        *":$dir:"*) ;;
        *) PATH="$dir:$PATH" ;;
    esac
}

# Append a directory to PATH only if it isn't already present (idempotent).
appendpath() {
    local dir="$1"
    [ -n "$dir" ] || return 0
    case ":$PATH:" in
        *":$dir:"*) ;;
        *) PATH="$PATH:$dir" ;;
    esac
}
