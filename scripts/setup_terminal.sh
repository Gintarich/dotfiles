setup_kitty_terminal() {
    local xdg_terminals_file="$HOME/.config/xdg-terminals.list"

    if command -v omarchy-install-terminal &> /dev/null; then
        echo "Setting kitty as default terminal via omarchy..."
        if omarchy-install-terminal kitty; then
            return
        fi

        echo "omarchy-install-terminal failed, using fallback..."
    fi

    echo "Setting kitty as default terminal via fallback..."
    install_packages kitty

    mkdir -p "$HOME/.config"
    cat > "$xdg_terminals_file" <<EOF
# Terminal emulator preference order for xdg-terminal-exec
# The first found and valid terminal will be used
kitty.desktop
EOF
}
