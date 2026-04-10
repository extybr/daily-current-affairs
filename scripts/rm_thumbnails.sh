#!/bin/bash
# $> ./rm_thumbnails.sh
# Удаление кэшированных изображений (thumbnails)

set -euo pipefail


trash_clean() {
  # очистка корзины
  find ~/.local/share/Trash -type f -delete 2>/dev/null
  # rm -rf ~/.local/share/Trash/{files,info}/*(N)  # альтернативная команда для zsh
  echo -e "Cleaned: \033[36mTrash\033[0m"
}

THUMB_DIRS=(
    "$HOME/.cache/thumbnails/x-large"
    "$HOME/.cache/thumbnails/normal"
    "$HOME/.cache/doublecmd/thumbnails"
    "$HOME/.cache/thumbnails/fail"
)

for dir in "${THUMB_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        rm -rf "$dir"/*
        echo -e "Cleaned: \033[36m$dir\033[0m"
    else
        echo -e "Skip (not found): \033[36m$dir\033[0m"
    fi
done

trash_clean
echo -e "Done at \033[36m$(date)\033[0m"
