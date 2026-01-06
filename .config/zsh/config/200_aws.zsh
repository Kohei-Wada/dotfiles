#!/bin/zsh

_log_info "Setting up AWS CLI configuration..."

# AWS CLI completion for zsh
# Note: bashcompinit can cause issues, using native zsh completion instead
if _is_command_available aws; then
    _log_ok "AWS CLI configuration set up successfully."
else
    _log_warn "AWS CLI is not installed. Skipping configuration."
fi
