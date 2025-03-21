#!/bin/bash
#shellcheck disable=SC1090
#shellcheck disable=SC1091

_log_info "Setting up Git configuration..."

export GIT_PAGER="LESSCHARSET=utf-8 less"

_log_ok "Git configuration set up successfully."
