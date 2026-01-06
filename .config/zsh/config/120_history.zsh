#!/bin/zsh

# Zsh equivalent of HISTIGNORE
# Use zshaddhistory hook function
zshaddhistory() {
    local line="${1%%$'\n'}"
    local cmd="${line%% *}"

    # List of commands to ignore
    case "$cmd" in
        ls|bg|fg|history|c|v|vi|vim|nvim)
            return 1  # Don't add to history
            ;;
    esac
    return 0  # Add to history
}
