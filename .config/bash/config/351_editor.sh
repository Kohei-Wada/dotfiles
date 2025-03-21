#!/bin/bash
#shellcheck disable=SC1090
#shellcheck disable=SC1091

_log_info "Setting up editor configuration..."

# Set default editor based on availability
for editor in nvim vim vi; do
    if _is_command_available "$editor"; then
        alias v='$editor'
        export GIT_EDITOR="$editor"
        export EDITOR="$editor"
        break
    fi
done

# If no editor found, fallback
if [ -z "${EDITOR:-}" ]; then
   _log_warn "No editor found. Please set EDITOR or GIT_EDITOR." 
fi

_log_ok "Editor configuration set to $EDITOR"
