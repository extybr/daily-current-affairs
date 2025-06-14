#!/bin/bash
# $> ./recover-deleted-files-from-repository.sh
# https://habr.com/ru/companies/bastion/articles/916752/
# Сканирование и восстановление удаленных файлов с репозитория

rec_del_files() {
  # cd в клонированный репозиторий
  mkdir -p "__ANALYSIS/del"
  # Извлекаем все коммиты и обрабатываем каждый
  git rev-list --all | while read -r commit; do
      echo "Processing commit: $commit"

      # Получаем родительский коммит
      parent_commit=$(git log --pretty=format:"%P" -n 1 "$commit")
      if [ -z "$parent_commit" ]; then
          continue
      fi
      parent_commit=$(echo "$parent_commit" | awk '{print $1}')

      # Получаем diff коммита
      git diff --name-status "$parent_commit" "$commit" | while read -r file_status file; do
          # Заменяем / на _ для имен файлов в binary_files_dir
          safe_file_name=$(echo "$file" | sed 's/\//_/g')

          # Обрабатываем удаленные файлы
          if [ "$file_status" = "D" ]; then
                  # Обрабатываем двоичные файлы
                  echo "Binary file deleted: $file" | tee -a "__ANALYSIS/del.log"
                  echo "Saving to __ANALYSIS/del/${commit}___${safe_file_name}"
                  git show "$parent_commit:$file" > "__ANALYSIS/del/${safe_file_name}"
          fi
      done
  done
}

rec_blobs() {
  # Извлечения всех недостижимых блобов
  mkdir -p unreachable_blobs && git fsck --unreachable --dangling --no-reflogs --full -  | \
  grep 'unreachable blob' | awk '{print $3}' | \
  while read h; do
    git cat-file -p "$h" > "unreachable_blobs/$h.blob"
  done
}

if [ "$#" -gt 0 ]; then
  rec_blobs
else rec_del_files
fi

