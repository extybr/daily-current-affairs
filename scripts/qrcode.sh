#!/bin/sh
YELLOW="\033[33m"
NORMAL="\033[0m"

if [ "$#" -ne 1 ]; then echo -e "${YELLOW}Ожидалось 1 параметр, а передано $#${NORMAL}"; exit 0; fi

file_name="grcode_$(date "+%d-%m-%y_%H-%M-%S").png"

trap "echo -e 'Папка с файлом: ${YELLOW}${PWD}${NORMAL}'; echo -e 'Название файла: ${YELLOW}${file_name}${NORMAL}'" EXIT

qrencode -o "${file_name}" -s 100 "$1"
