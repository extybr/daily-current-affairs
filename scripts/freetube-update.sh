#!/bin/bash
# $> ./freetube-update.sh
# Обновление FreeTube

set -e

# путь до папки
freetube_dir="$HOME/my_programs/freetube-linux-x64-portable"

chkv=$(curl -s "https://api.github.com/repos/FreeTubeApp/FreeTube/releases" | jq -r '.[0].tag_name')
if [[ -z "${chkv}" || "${#chkv}" -gt 20 ]]; then
  echo "недостоверные данные (неверный запрос или нет сети)" && exit 1
fi

link="https://github.com/FreeTubeApp/FreeTube/releases/download/${chkv}/freetube-${chkv#*v}-linux-x64-portable.zip"

cd "$freetube_dir" && ( for file in $(ls ./); do rm -rf "$file"; done ) || ( echo "нет папки: $freetube_dir" && exit 1 )
wget "$link"  # скачивание архива с программой
archive="${link##*/}"
if ! [ -f "$archive" ]; then echo "ошибка с файлом архива" && exit 1; fi
unzip "$archive"  # разархивирование программы
rm "$archive"  # удаление архива

