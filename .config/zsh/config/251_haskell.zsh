#!/bin/zsh
#shellcheck disable=SC1090,SC1091

_log_info "Setting up Haskell configuration..."

# Add GHCup to PATH and source its environment if available
if _is_command_available ghcup; then
    _log_info "GHCup found. Adding to PATH and sourcing environment..."
    appendpath "$HOME/.ghcup/bin"
fi

# Stack zsh completion requires proper fpath setup
# The completion script uses compadd which only works in completion context
# For now, skip automatic completion setup

_log_ok "Haskell configuration set up successfully."
