#!/bin/bash

_log_info "Setting up Alias..."

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias c='clear'
alias h='history'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# enable color support of ls and also add handy aliases
if _is_command_available 'dircolors'; then
    _log_info "Setting up color support for ls..."

    if test -r ~/.dircolors; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi

    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    _log_warn "dircolors is not available. Skipping color support for ls."
    alias ls='ls -F'
    alias dir='dir -F'
    alias vdir='vdir -F'
fi

alias gd='pushd'
alias pd='popd'

_log_ok "Alias set up successfully."
