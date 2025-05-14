#!/bin/bash

readonly TPM_PATH="$HOME/.local/share/tmux/plugins/tpm"

if [ -d "$TPM_PATH" ]; then
    echo "tmux plugin manager already installed"
else
    echo "installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm "$TPM_PATH"
fi
