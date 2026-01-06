#!/bin/zsh
#shellcheck disable=SC1090
#shellcheck disable=SC1091

_log_info "Setting up zsh configuration..."

# History configuration
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

if ! _file_exists "$HISTFILE"; then
    _log_info "Creating history file at $HISTFILE"
    mkdir -p "${XDG_STATE_HOME}/zsh"
    touch "$HISTFILE"
fi

# Zsh options (equivalent to bash shopt/HISTCONTROL)
setopt APPEND_HISTORY       # Append to history file (like shopt -s histappend)
setopt HIST_IGNORE_DUPS     # Ignore consecutive duplicates (HISTCONTROL=ignoredups)
setopt HIST_IGNORE_SPACE    # Ignore commands starting with space (HISTCONTROL=ignorespace)
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks
setopt SHARE_HISTORY        # Share history between sessions
setopt EXTENDED_GLOB        # Extended globbing (like shopt -s globstar)
setopt NO_FLOW_CONTROL      # Disable Ctrl-S/Ctrl-Q (like stty stop/start undef)

# PATH additions
export PATH=$PATH:$HOME/.bin:$HOME/bin:$HOME/.local/bin

_log_ok "Zsh configuration set up successfully."
