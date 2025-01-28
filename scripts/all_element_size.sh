#!/bin/bash
###############################
# $> ./all_element_size.sh ~  #
###############################

# определяет является ли элемент в папке папкой или 
# файлом (включая начинающиеся с точки), а также его размер

path="$1"

[[ ! -d "${path}" ]] && echo "*** папка не найдена ***" && exit 1

IFS=$'\n'
for item in $(ls -Al "${path}" | tr -s " " | cut -d " " -f5,9-15); do
  elem=$(echo "${item}" | cut -d " " -f2-5)
  if [ -d "${path}/${elem}" ]; then
    echo "$(du -sh ${path}/${elem} 2> /dev/null) is folder"
  elif [ -f "${path}/${elem}" ]; then
    echo "${item} is file"
  fi
done

