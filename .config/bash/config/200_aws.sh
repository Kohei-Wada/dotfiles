#!/bin/bash

_log_info "Setting up AWS CLI configuration..."

if [ -f '/usr/local/bin/aws_completer' ]; then
    complete -C '/usr/local/bin/aws_completer' aws
else
   _log_warn "AWS CLI completer not found. Skipping AWS CLI completion setup."
fi

_log_ok "AWS CLI configuration set up successfully."
