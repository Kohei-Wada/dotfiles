#!/bin/bash

_log_info "Setting up fzf configuration..."

if _is_command_available fzf; then
    # Function to select and SSH into a host
    _fssh() {
        local host
        host=$(grep -H -R '^Host' ~/.ssh | awk '{ print $2 }' | grep -v '\*' | fzf)
        if [ -n "$host" ]; then
            ssh -A "$host" || return 1
        else
            echo "No SSH host selected."
            return 1
        fi
    }

    # Set default fzf options
    export FZF_DEFAULT_OPTS='--height 40% --reverse --inline-info'

    # Initialize fzf key bindings
    eval "$(fzf --bash)"

    # Bind keys for fzf functions
    bind '"\C-o": "_fssh\C-m"'

    if _is_command_available ghq; then
        # Function to select and navigate to a repository
        _frepo() {
            local repo
            repo=$(ghq list -p | fzf --preview="ls -al --color=always {}")
            if [ -n "$repo" ]; then
                cd "$repo" || return 1
            else
                echo "No repository selected."
                return 1
            fi
        }
        bind '"\C-g": "_frepo\C-m"'
    else
        _log_warn "ghq is not installed. Skipping repository navigation setup."
    fi

    _log_ok "fzf configuration set up successfully."
else
    _log_warn "fzf is not installed. Skipping fzf configuration."
fi
