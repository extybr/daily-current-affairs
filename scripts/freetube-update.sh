#!/bin/bash
# $> ./freetube-update.sh
# Обновление FreeTube

set -e

# путь до папки
freetube_dir="$HOME/my_programs/freetube-linux-x64-portable"
github_scan_dir="$GITHUB_DIRECTORY/github_scan_dir"

check_path() {
  # проверка путей
  quit=false
  if ! [ -d "$github_scan_dir" ] && echo "нет папки: $github_scan_dir"; then
    quit=true
  fi
  if ! [ -d "$freetube_dir" ] && echo "нет папки: $freetube_dir"; then
    quit=true
  fi
  if ! [ -f "$github_scan_dir/github_release_version.sh" ] && echo "нет файла: github_release_version.sh"; then
     quit=true
  fi
  if [[ "$quit" == true ]]; then
    exit 1
  fi
}

# check_path  # не использую функцию проверки путей папок и файла

cd "$github_scan_dir" || ( echo "нет папки: $github_scan_dir" && exit 1 )

chkv=$(./github_release_version.sh FreeTubeApp FreeTube)     
if [[ "${#chkv}" -lt 53 ]]; then
  echo "недостоверные данные (неверный запрос или нет сети)" && exit 1
fi

version=$(echo "${chkv##*/v}")  # обрезка строки
version="${version::-4}"  # убираю лишние символы скрипта github_release_version.sh

link="https://github.com/FreeTubeApp/FreeTube/releases/download/v${version}/freetube-${version}-linux-x64-portable.zip"

cd "$freetube_dir" && ( for file in $(ls ./); do rm -rf "$file"; done ) || ( echo "нет папки: $freetube_dir" && exit 1 )
wget "$link"  # скачивание архива с программой
archive="${link##*/}"
if ! [ -f "$archive" ]; then echo "ошибка с файлом архива" && exit 1; fi
unzip "$archive"  # разархивирование программы
rm "$archive"  # удаление архива

