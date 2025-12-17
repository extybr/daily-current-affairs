#!/bin/bash
# $> ./build_and_run_image.sh bot
# Сборка образа и запуск контейнера

set -e

if [ "$#" -ne 1 ]; then
  echo "*** Необходимо передать название образа ***" && exit 1
fi
image="$1"

cur_dir=$(pwd)  # текущая директория

# спрашиваем путь до папки сборки образа
while read -rp "Путь до папки сборки образа: " path; do
  # если папка с файлом Dockerfile существует, то запоминаем путь и выходим с цикла
  if [ -f "$path/Dockerfile" ]; then
    cd "$path" && break
  fi
done

docker build -t "$image" .  # запуск процесса создания образа
docker run -d --network host --restart=always "$image"  # запуск контейнера

cd "$cur_dir"  # возврат в текущую директорию

