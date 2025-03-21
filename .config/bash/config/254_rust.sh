#!/bin/bash
# shellcheck disable=SC1090,SC1091

_log_info "Setting up Rust configuration..."

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
else
    _log_warn "$HOME/.cargo/env not found. Skipping Rust configuration."
    return
fi

_log_ok "Rust configuration set up successfully."
