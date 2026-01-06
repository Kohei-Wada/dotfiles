#!/bin/zsh
#shellcheck disable=SC1090
#shellcheck disable=SC1091

_log_info "Setting up zoxide configuration..."

# WARNING: zoxide must be loaded at the end of the zshrc file
if _is_command_available zoxide; then
    eval "$(zoxide init zsh)"
    _log_ok "Zoxide configuration set up successfully."
else
    _log_warn "Zoxide is not installed. Skipping configuration."
fi
