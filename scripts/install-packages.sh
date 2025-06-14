#!/bin/bash

packages=(
    btop
    )

for package in ${packages[@]}; do
    yay -S --noconfirm ${package}
done


