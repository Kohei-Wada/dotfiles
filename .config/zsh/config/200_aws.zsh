#!/bin/zsh

_log_info "Setting up AWS CLI configuration..."

if [[ -f '/usr/local/bin/aws_completer' ]]; then
    # Zsh way to use external completer via bashcompinit
    autoload -Uz bashcompinit
    bashcompinit
    complete -C '/usr/local/bin/aws_completer' aws
    _log_ok "AWS CLI configuration set up successfully."
else
    _log_warn "AWS CLI completer not found. Skipping AWS CLI completion setup."
fi
