#!/bin/bash
# shellcheck disable=SC1090,SC1091

_log_info "Setting up less configuration..."
export PAGER=less

# Use lesspipe for non-text input files if available
if _is_command_available 'lesspipe.sh'; then
    eval "$(SHELL=/bin/sh lesspipe.sh)"
else
    _log_warn "lesspipe is not installed. Skipping less configuration."
    return
fi

_log_ok "Less configuration set up successfully."
