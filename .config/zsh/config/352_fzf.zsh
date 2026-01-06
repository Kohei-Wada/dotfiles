#!/bin/zsh

_log_info "Setting up fzf configuration..."

if _is_command_available fzf; then
    # Function to select and SSH into a host
    _fssh() {
        local host
        host=$(grep -H -R '^Host' ~/.ssh 2>/dev/null | awk '{ print $2 }' | grep -v '\*' | fzf)
        if [[ -n "$host" ]]; then
            echo "Connecting to $host..."
            ssh "$host" || return 1
        else
            echo "No SSH host selected."
            return 1
        fi
    }

    # Set default fzf options
    export FZF_DEFAULT_OPTS='--height 40% --reverse --inline-info'

    # Initialize fzf key bindings for zsh
    eval "$(fzf --zsh)"

    # Create a zle widget for _fssh
    _fssh_widget() {
        _fssh
        zle reset-prompt
    }
    zle -N _fssh_widget
    bindkey '^O' _fssh_widget

    if _is_command_available ghq; then
        # Function to select and navigate to a repository
        _frepo() {
            local repo
            repo=$(ghq list -p | fzf --preview="ls -al --color=always {}")
            if [[ -n "$repo" ]]; then
                cd "$repo" || return 1
            else
                echo "No repository selected."
                return 1
            fi
        }

        # Create a zle widget for _frepo
        _frepo_widget() {
            _frepo
            zle reset-prompt
        }
        zle -N _frepo_widget
        bindkey '^G' _frepo_widget
    else
        _log_warn "ghq is not installed. Skipping repository navigation setup."
    fi

    _log_ok "fzf configuration set up successfully."
else
    _log_warn "fzf is not installed. Skipping fzf configuration."
fi
