#!/bin/bash 


if command -v rclone &> /dev/null; then
    echo "rclone installed"
else
    # Install rclone
    sudo pacman -S rclone
    # After type rclone config
fi

rclone --vfs-cache-mode writes mount OneDrive: ~/OneDrive &
notify-send "OneDrive connected"
