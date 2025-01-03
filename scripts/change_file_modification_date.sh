#!/bin/bash
# $> ./change_file_modification_date.sh '~/Documents/file.txt'

normal="\033[0m"
yellow="\033[33m"
blue="\033[36m"
white="\033[37m"

if [ "$#" -ne 1 ]; then
  echo -e "${white}Ожидалось 1 параметр${normal}"
  exit 0
fi

if ! [ -f "$1" ]; then
  echo -e "${white}Файл не найден${normal}"
  exit 0
fi

dt=$(date "+%y-%m-%d %H:%M:%S")

touch -d "${dt}" "$1"

file=$(basename "$1")
echo -e "${yellow}Файл: ${blue}${file}\n${yellow}Дата изменения: ${blue}${dt}${normal}"

