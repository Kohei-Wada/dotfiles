#!/bin/zsh
#shellcheck disable=SC2155,SC2034,SC2148

# If not interactive shell, return
[[ -o interactive ]] || return

# Initialize completion system early
autoload -Uz compinit
compinit

# Vi mode
bindkey -v

# Edit command line in editor with 'v' in vicmd mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Menu completion bindings
bindkey -M viins '^N' menu-complete
bindkey -M vicmd '^N' menu-complete

# Load modular configuration
loader="$HOME/.config/zsh/load.zsh"
if [[ -f "$loader" ]]; then
    source "$loader"
else
    echo "Loader script not found: $loader"
fi

# Atuin shell history (load after other configs)
if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh)"
fi
