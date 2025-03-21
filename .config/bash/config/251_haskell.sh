#!/bin/bash
#shellcheck disable=SC1090,SC1091

_log_info "Setting up Haskell configuration..."

# Add GHCup to PATH and source its environment if available
if [ -f "$HOME/.ghcup/env" ]; then
  export PATH="$PATH:$HOME/.ghcup/bin"
  source "$HOME/.ghcup/env"
fi

# Enable Stack bash completion if Stack is installed
if _is_command_available stack; then
  _log_info "Enabling Stack bash completion..."
  eval "$(stack --bash-completion-script stack)"
fi

_log_ok "Haskell configuration set up successfully."

