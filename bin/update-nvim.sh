#!/bin/bash

set -e

# Fetch the latest Neovim version and construct the download URL
latest_version=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
release_filename='nvim-linux-x86_64.tar.gz'
nvim_url="https://github.com/neovim/neovim/releases/download/${latest_version}/${release_filename}"

# Define paths
download_path='/tmp/nvim-linux-x86_64.tar.gz'
install_path="/opt/${release_filename%.tar.gz}"

# Display progress
echo "Latest Neovim version: $latest_version"
echo "Downloading Neovim from: $nvim_url"

# Download the release
curl -L -o "$download_path" "$nvim_url" > /dev/null 2>&1
echo "Downloaded Neovim to $download_path"

# Remove old installation if it exists
if [ -d "$install_path" ]; then
    echo "Removing old version of Neovim from $install_path"
    sudo rm -rf "$install_path"
fi

# Install the new version
echo "Installing Neovim to $install_path"
sudo tar -xzf "$download_path" -C /opt/
echo "Neovim installed to $install_path"

