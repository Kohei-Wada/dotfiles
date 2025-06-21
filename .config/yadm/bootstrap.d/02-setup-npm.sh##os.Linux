#!/usr/bin/env bash

echo "Setting up npm global packages..."
if command -v npm >/dev/null 2>&1; then
    # Create a directory for your global packages
    mkdir -p ~/.npm-global

    # Configure npm to use the new directory path
    npm config set prefix ~/.npm-global
    echo "npm global packages setup complete."
else
    echo "npm is not installed. Please install npm to set up global packages."
fi
