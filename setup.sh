#!/bin/bash

sudo apt update

declare -a common_packages=(
exa curl wget git zsh tmux bat fzf unzip ripgrep ncdu ranger stow clang
)

sudo apt install "${common_packages[@]}" -y

if [[ -f /usr/bin/nvim ]]; then
    echo "nvim installed"
else
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install neovim -y
    stow -vt ~ nvim
    git config --global user.email "gintars.briedis@gmail.com"
    git config --global user.name "Gintars Briedis"
fi

if [[ -f /usr/local/bin/lazygit ]]; then
    echo "Lazy git installed"
else
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
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

#links stuff
if [[ -d ~/.config/nvim ]]; then
    echo ""
else
    stow -vt ~ nvim zsh tmux
fi
