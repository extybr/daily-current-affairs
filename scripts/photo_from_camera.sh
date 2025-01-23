#!/bin/bash
# $> ./photo_from_camera.sh
# Делает фото с камеры гаджета

sleep 1
dt=$(date "+%d-%m-%y_%H-%M-%S")
folder="Изображения"
file="${HOME}/${folder}/${dt}.png"
ffmpeg -y -t 1 -f video4linux2 -s 1920x1080 -i /dev/video0 -frames:v 1 -f image2 "${file}" &> /dev/null
echo -e "\e[036mФото сохранено: \e[37m${file}\e[0m"

