#!/bin/bash
# $> ./qrcode.sh https://t.me/extybr_bot
# Для генерации qr-кода

yellow="\033[33m"
normal="\033[0m"

if [ "$#" -ne 1 ]; then 
  echo -e "${yellow}Ожидалось 1 параметр, а передано $#${normal}"
  exit 0
fi

file_name="grcode_$(date "+%d-%m-%y_%H-%M-%S").png"

trap "echo -e 'Папка с файлом: ${yellow}${PWD}${normal}'; echo -e 'Название файла: ${yellow}${file_name}${normal}'" EXIT

qrencode -o "${file_name}" -s 100 "$1" || exit 1

