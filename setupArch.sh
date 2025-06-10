#!/bin/bash

# Array of common packages to install
declare -a common_packages=(
    exa curl wget git zsh tmux bat fzf unzip ripgrep ncdu ranger stow clang wofi swayimg hyprpaper
)

# Install common packages if not already present
sudo pacman -S --noconfirm "${common_packages[@]}"

# Check if Neovim is installed
if command -v nvim &> /dev/null; then
    echo "nvim installed"
else
    # Install Neovim from the official repositories
    sudo pacman -S --noconfirm neovim

    # Configure Git user information
    git config --global user.email "gintars.briedis@gmail.com"
    git config --global user.name "Gintars Briedis"
fi

# Check if lazygit is installed
if command -v lazygit &> /dev/null; then
    echo "lazygit installed"
else
    # Install lazygit from the community repository
    sudo pacman -S --noconfirm lazygit
fi

#Shell stuff
#You can change zsh env in : nvim /etc/zsh/zshenv
#add this there ZDOTDIR=~/.config/zsh
#echo $SHELL
#Sets shell to zsh if its not set
if [[ $SHELL != /usr/bin/zsh ]]; then
    echo "zsh not installed"    
    chsh -s $(which zsh)
fi

stow -vt ~ nvim zsh tmux hypr

#yay stuff
#hyprshot for screeshots
yay -S hyprshot
#notification Daemon
yay -S swaync 
