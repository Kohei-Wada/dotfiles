#!/bin/zsh

_log_info "Setting up AWS CLI configuration..."

# AWS CLI completion for zsh using bashcompinit
if _is_command_available aws; then
    autoload -Uz bashcompinit
    bashcompinit
    if [[ -f '/usr/local/bin/aws_completer' ]]; then
        complete -C '/usr/local/bin/aws_completer' aws
    elif [[ -f '/usr/bin/aws_completer' ]]; then
        complete -C '/usr/bin/aws_completer' aws
    fi
    _log_ok "AWS CLI configuration set up successfully."
else
    _log_warn "AWS CLI is not installed. Skipping configuration."
fi
