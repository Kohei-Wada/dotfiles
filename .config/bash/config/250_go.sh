#!/bin/bash

_log_info "Setting up Go configuration..."

appendpath "$HOME/go/bin"
appendpath "/usr/local/go/bin"

_log_ok "Go configuration set up successfully."
