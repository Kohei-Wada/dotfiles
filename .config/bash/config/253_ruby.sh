#!/bin/bash
#shellcheck disable=SC2155

_log_info "Setting up Ruby configuration..."

if gem env path &> /dev/null; then
    export PATH="$PATH:$(gem env path | sed 's#[^:]\+#&/bin#g')"
fi

_log_ok "Ruby configuration set up successfully."
