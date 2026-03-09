#!/bin/bash

source ./scripts/setup-zsh.sh
source ./scripts/utils.sh
source ./scripts/setup_git.sh

# Array of common packages to install
declare -a PACKAGES=(
    curl wget git zsh tmux bat fzf unzip ripgrep stow clang wofi npm lsof bun
)

install_packages "${PACKAGES[@]}"

# Install common packages if not already present
# sudo pacman -S --noconfirm "${common_packages[@]}"

setup_git

# Check if Neovim is installed
if command -v nvim &> /dev/null; then
    echo "nvim installed"
else
    # Install Neovim from the official repositories
    sudo pacman -S --noconfirm neovim

fi

# Check if lazygit is installed
if command -v lazygit &> /dev/null; then
    echo "lazygit installed"
else
    # Install lazygit from the community repository
    sudo pacman -S --noconfirm lazygit
fi


stow -vt ~ nvim zsh tmux

install_zsh
