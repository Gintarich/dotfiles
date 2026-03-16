#!/bin/bash

source ./scripts/setup-zsh.sh
source ./scripts/utils.sh
source ./scripts/prepare_stow_targets.sh
source ./scripts/setup_terminal.sh
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


prepare_stow_target_links
stow -vt ~ nvim zsh tmux kitty

setup_kitty_terminal
install_zsh
