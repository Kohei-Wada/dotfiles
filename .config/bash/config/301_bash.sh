#!/bin/bash
#shellcheck disable=SC1090
#shellcheck disable=SC1091

_log_info "Setting up bash configuration..."

# history
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
export HISTFILE="${XDG_STATE_HOME}"/bash/history

if ! _file_exists "$HISTFILE"; then
  _log_info "Creating history file at $HISTFILE"
  mkdir -p "${XDG_STATE_HOME}"/bash
  touch "$HISTFILE"
fi

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
stty stop undef
stty start undef

set -o vi

appendpath "$HOME/.bin"
appendpath "$HOME/bin"
appendpath "$HOME/.local/bin"

_log_ok "Bash configuration set up successfully."

_log_info "Setting up bash completion..."
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

_log_ok "Bash completion set up successfully."
