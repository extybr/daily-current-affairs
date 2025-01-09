#!/bin/bash
##############################################
# $> ./check_name_size.sh folder-1 folder-2  #
##############################################

# раскраска текста
WHITE="\033[37m"
RED="\033[31m"
BLUE="\033[36m"
VIOLET="\033[35m"
YELLOW="\033[33m"
NORMAL="\033[0m"

# проверка на количество параметров
if [ "$#" -ne 2 ]; then
  echo -e "${WHITE}ожидалось 2 параметра, а передано $#${NORMAL}"
  exit 0
fi

if ! [ -d "$1" ] || ! [ -d "$2" ]; then
  echo -e "${WHITE}ошибка в указании названия/пути папок${NORMAL}"
  exit 0
fi

# начальное сообщение
echo -e "${VIOLET}Сравнение файлов первой папки с файлами из второй папки по имени и размеру${NORMAL}"
echo

IFS=$'\n'
files=$(ls "$1")
for file in ${files}
do
  file_folder_1=$(du -s "$1/${file}")
  echo "${file_folder_1}"
  if ! du -s "$2/${file}" 2> /dev/null
  then echo -e "${RED}Файл отсутствует во второй папке${NORMAL}"; echo ; continue
  else file_folder_2=$(du -s "$2/${file}")
    size_file_folder_2=$(echo "${file_folder_2}" | sed "s/"$(basename $2)"/"$(basename $1)"/g")
    if [ "${size_file_folder_2}" == "${file_folder_1}" ]
      then echo -e "${BLUE}Файлы идентичны${NORMAL}"; echo; continue
    else echo -e "${YELLOW}Файлы разные по размеру${NORMAL}"
    fi
  fi
  echo
done
