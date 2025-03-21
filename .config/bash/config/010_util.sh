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

_is_file_exists() {
    local file="$1"
    [ -f "$file" ]
}

_is_directory_exists() {
    local dir="$1"
    [ -d "$dir" ]
}
