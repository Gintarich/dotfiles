ZDOTDIR_LINE='export ZDOTDIR="$HOME/.config/zsh"'
ZSHENV_PATH="$HOME/.zshenv"

install_zsh() {
    # 1. If ~/.zshenv does NOT exist -> create it with the line
    if [ ! -f "$ZSHENV_PATH" ]; then
        echo "Creating $ZSHENV_PATH and adding ZDOTDIR..."
        {
            echo '# Set ZDOTDIR so zsh reads configs from ~/.config/zsh'
            echo "$ZDOTDIR_LINE"
        } >> "$ZSHENV_PATH"
    else
        # 2. File exists -> check if the exact line is already there
        if grep -Fxq "$ZDOTDIR_LINE" "$ZSHENV_PATH"; then
            echo "$ZSHENV_PATH already contains ZDOTDIR, nothing to do."
        else
            echo "Appending ZDOTDIR to $ZSHENV_PATH..."
            {
                echo ""
                echo '# Set ZDOTDIR so zsh reads configs from ~/.config/zsh'
                echo "$ZDOTDIR_LINE"
            } >> "$ZSHENV_PATH"
        fi
    fi
}
