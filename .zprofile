#!/bin/zsh
# Login shell configuration (runs once at login)

# Load .env file if exists
if [[ -f "$HOME/.env" ]]; then
    source "$HOME/.env"
fi
