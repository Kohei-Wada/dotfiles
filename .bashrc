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
