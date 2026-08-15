#!/bin/bash
# shellcheck disable=SC1090,SC1091

_log_info "Setting up Rust configuration..."

if _is_command_available rustup; then
    appendpath "$HOME/.cargo/bin"
else
    _log_warn "rustup is not installed. Skipping Rust configuration."
fi

_log_ok "Rust configuration set up successfully."
