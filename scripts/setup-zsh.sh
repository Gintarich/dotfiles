ZDOTDIR_LINE='export ZDOTDIR="$HOME/.config/zsh"'
USER_ZSHENV_PATH="$HOME/.zshenv"
GLOBAL_ZSHENV_PATH="/etc/zsh/zshenv"

ensure_user_zdotdir() {
    if [ ! -f "$USER_ZSHENV_PATH" ]; then
        echo "Creating $USER_ZSHENV_PATH and adding ZDOTDIR..."
        {
            echo '# Set ZDOTDIR so zsh reads configs from ~/.config/zsh'
            echo "$ZDOTDIR_LINE"
        } >> "$USER_ZSHENV_PATH"
        return
    fi

    if grep -Fxq "$ZDOTDIR_LINE" "$USER_ZSHENV_PATH"; then
        echo "$USER_ZSHENV_PATH already contains ZDOTDIR."
    else
        echo "Appending ZDOTDIR to $USER_ZSHENV_PATH..."
        {
            echo ""
            echo '# Set ZDOTDIR so zsh reads configs from ~/.config/zsh'
            echo "$ZDOTDIR_LINE"
        } >> "$USER_ZSHENV_PATH"
    fi
}

ensure_global_zdotdir() {
    if grep -qE '^\s*(export\s+)?ZDOTDIR=' "$GLOBAL_ZSHENV_PATH" 2>/dev/null; then
        echo "ZDOTDIR already configured in $GLOBAL_ZSHENV_PATH."
    else
        echo "$ZDOTDIR_LINE" | sudo tee -a "$GLOBAL_ZSHENV_PATH" > /dev/null
        echo "Added ZDOTDIR to $GLOBAL_ZSHENV_PATH."
    fi
}

ensure_default_shell_is_zsh() {
    if [[ "$SHELL" != /usr/bin/zsh ]]; then
        echo "Default shell is not zsh. Switching..."
        chsh -s "$(which zsh)"
    fi
}

install_zsh() {
    ensure_user_zdotdir
    ensure_global_zdotdir
    ensure_default_shell_is_zsh
}
