#!/bin/bash
#shellcheck disable=SC2155

_log_info "Setting up Ruby configuration..."

if gem env path &> /dev/null; then
    _gem_paths=$(gem env path 2>/dev/null | tr ':' '\n' | sed 's#[^/]*$##')
    _gem_paths=$(echo "$_gem_paths" | tr '\n' ' ')
    for _gp in $_gem_paths; do
        appendpath "$_gp"
    done
    unset _gp _gem_paths
fi

_log_ok "Ruby configuration set up successfully."
