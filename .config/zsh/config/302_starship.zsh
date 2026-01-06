#!/bin/zsh

_log_info "Setting up Starship configuration..."

if _is_command_available 'starship'; then
    eval "$(starship init zsh)"
    _log_ok "Starship configuration set up successfully."
else
    _log_warn "Starship is not installed. Skipping configuration."
fi
