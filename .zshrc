#shellcheck disable=SC2155,SC2034,SC2148

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/kohei/.zshrc'

bindkey -v

autoload -Uz compinit
compinit
# End of lines added by compinstall


# if atuin is installed, initialize it
if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh)"
fi

# if atuin is installed, initialize it
if command -v atuin >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

bindkey -M viins '^N' menu-complete
bindkey -M vicmd '^N' menu-complete
