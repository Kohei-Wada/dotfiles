#!/bin/bash

if [ -d ~/.tmux/plugins/tpm ]; then
    echo "tmux plugin manager already installed"
else
    echo "installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
