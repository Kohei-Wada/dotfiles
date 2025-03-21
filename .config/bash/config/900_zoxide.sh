#!/bin/bash
#shellcheck disable=SC1090
#shellcheck disable=SC1091


_log_info "Setting up zoxide configuration..."

# WARNING: zoxide must be loaded at the end of the bashrc file
if  _is_command_available zoxide; then
    eval "$(zoxide init bash)"
    _log_ok "Zoxide configuration set up successfully."
else
    _log_warn "Zoxide is not installed. Skipping configuration."
fi

