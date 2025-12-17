#!/bin/bash
# $> ./stop_and_rm_container_image.sh bot
# Остановка, удаление запущенного контейнера. Удаление его образа.

if [ "$#" -ne 1 ]; then
  echo "*** Необходимо передать название образа ***" && exit 1
fi
image="$1"

container=$(docker ps | tail +2 | awk '{print $1}')  # определяем id запущенного контейнера
docker stop "$container" && docker rm "$container"  # остановка контейнера и его удаление по id
docker rmi "$image"  # удаление его локального образа

