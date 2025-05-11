#!/bin/bash
# shellcheck disable=SC2086,SC1091

echo "Checking OS version..."
source /etc/os-release
system_version=$ID
echo "System version: $system_version"

arch_packages=$(cat <<EOF
git
neovim
ripgrep
fd
fzf
bat
exa
tmux
btop
jq
ghq
zoxide
dust
uv
gcc
make
cmake
github-cli
starship
yazi
glow
fastfetch
pinentry
pre-commit
EOF
)

# if archlinux
if [[ $system_version == *"arch"* ]]; then
    echo "Installing packages for Arch Linux..."
    sudo pacman -Syu --noconfirm

    # WARNING: dont't quote $arch_packages
    sudo pacman -S --needed --noconfirm $arch_packages
    echo "Packages installed successfully."
fi
