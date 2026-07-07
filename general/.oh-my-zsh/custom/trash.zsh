# Globals
typeset -gr TRASH_DIR="$HOME/.local/share/Trash"

# Aliases
alias t-restore="trash-restore"

t-fix-permissions() {
    sudo chown -R "$USER:$USER" "$TRASH_DIR"
}

t-size() {
    du -shc "$TRASH_DIR"
}

t-empty() {
    local files_dir="$TRASH_DIR/files"
    local info_dir="$TRASH_DIR/info"
    local empty_dir
    local confirm
    local status

    [[ -d "$files_dir" && -d "$info_dir" ]] || { echo "Trash directory is missing."; return 1; }
    if ! find "$files_dir" "$info_dir" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
        echo "Trash is already empty."
        return
    fi

    printf "Are you sure? [y/N] "
    read -r confirm
    case "$confirm" in
        [yY]) ;;
        *) echo "Cancelled"; return ;;
    esac

    empty_dir="$(mktemp -d)" || return 1

    rsync -a --delete "$empty_dir"/ "$files_dir"/ &&
    rsync -a --delete "$empty_dir"/ "$info_dir"/

    rmdir "$empty_dir"
}
