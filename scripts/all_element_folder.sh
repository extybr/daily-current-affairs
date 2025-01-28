#!/bin/bash
################################
# $> ./all_element_size.sh ~   #
################################
# Определяет является ли объект файлом или папкой в указанной директории

path="$1"

[[ ! -d "${path}" ]] && echo "*** folder not found ***" && exit 1

IFS=$'\n'
for item in $(ls -A ${path} | tr -d "\t"); do
  if [ -d ${path}/${item} ]; then echo "${item} is folder"
  elif [ -f ${path}/${item} ]; then echo "${item} is file"; fi
  echo
done

