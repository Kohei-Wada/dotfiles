#!/bin/bash
#shellcheck disable=SC1090,SC1091

_log_info "Setting up JavaScript environment configuration..."

# Load NVM if available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Add Deno and Bun to front of PATH (idempotent)
export DENO_INSTALL="$HOME/.deno"
addpath "$DENO_INSTALL/bin"
addpath "$HOME/.bun/bin"

# Add npm global packages to front of PATH (idempotent)
addpath "$HOME/.npm-global/bin"

# Configure Node.js with readline support if rlwrap is available
if _is_command_available rlwrap; then
    alias node='NODE_NO_READLINE=1 rlwrap node'
else
    _log_warn "rlwrap not found, using node without readline support."
fi

_log_ok "JavaScript environment configuration set up successfully."
