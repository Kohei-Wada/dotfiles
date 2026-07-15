#!/bin/bash
# shellcheck disable=SC1090,SC1091,SC2034

# if not interactive shell, return
[[ $- == *i* ]] || return

# for debug bashrc
DEBUG_BASHRC=false

loader="$HOME/.config/bash/load.sh"
if [ -f "$loader" ]; then
    source "$loader"
else
    echo "Loader script not found: $loader"
fi

# load .env file
if [ -f "$HOME/.env" ]; then
    source "$HOME/.env"
fi

export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/ssh-agent.socket"

. "$HOME/.local/share/../bin/env"
