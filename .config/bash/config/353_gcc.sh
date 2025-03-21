#!/bin/bash
# shellcheck disable=SC1090,SC1091

_log_info "Setting up GCC configuration..."

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

_log_ok "GCC configuration set up successfully."
