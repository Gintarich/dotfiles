prepare_stow_target_links() {
    local script_dir repo_root timestamp backup_root backup_created
    script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
    repo_root="$(cd -- "$script_dir/.." && pwd)"
    timestamp="$(date +%Y%m%d-%H%M%S)"
    backup_root="$HOME/.config/.omarchy-replaced-$timestamp"
    backup_created=0

    local packages=("nvim" "zsh" "tmux" "kitty")

    for pkg in "${packages[@]}"; do
        local rel_path source_path target_path desired_path current_path backup_path
        rel_path=".config/$pkg"
        source_path="$repo_root/$pkg/$rel_path"
        target_path="$HOME/$rel_path"

        if [ ! -e "$target_path" ] && [ ! -L "$target_path" ]; then
            continue
        fi

        desired_path="$(readlink -f "$source_path")"

        if [ -L "$target_path" ]; then
            current_path="$(readlink -f "$target_path")"
            if [ "$current_path" = "$desired_path" ]; then
                echo "$target_path already points to dotfiles."
                continue
            fi

            echo "Replacing symlink at $target_path"
            rm "$target_path"
            continue
        fi

        if [ "$backup_created" -eq 0 ]; then
            mkdir -p "$backup_root"
            backup_created=1
        fi

        backup_path="$backup_root/$rel_path"
        mkdir -p "$(dirname "$backup_path")"
        mv "$target_path" "$backup_path"
        echo "Backed up $target_path to $backup_path"
    done

    if [ "$backup_created" -eq 1 ]; then
        echo "Existing configs were backed up to: $backup_root"
    fi
}
