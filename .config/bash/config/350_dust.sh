#!/bin/bash
# shellcheck disable=SC1090,SC1091

_log_info "Setting up dust alias..."

if _is_command_available "dust"; then
    alias du='dust -c'
    _log_ok "Dust alias set up successfully."
else
    alias du='du -h --max-depth=1'
    _log_warn "'dust' command not found. Using default 'du' command."
fi

