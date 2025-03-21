#!/bin/bash

_log_info "Setting up Go configuration..."

export PATH="$PATH:$HOME/go/bin"
export PATH=$PATH:/usr/local/go/bin

_log_ok "Go configuration set up successfully."
