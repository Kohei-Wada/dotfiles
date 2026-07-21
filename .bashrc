#!/bin/bash
# shellcheck disable=SC1090,SC1091,SC2034

# load .env file
# set -a: .env holds bare assignments, so without it they stay shell-local and
# child processes (opencode, scripts) never see them
if [ -f "$HOME/.env" ]; then
    set -a
    source "$HOME/.env"
    set +a
fi

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
