#!/bin/bash
#################################
# $> ./element_in_folder.sh ~   #
#################################
# Показывает является ли объект файлом или папкой в указанной директории

if [ "$#" -ne 1 ]
  then folder="${HOME}"
else folder="$1"
  if ! test -d "${folder}"; then
    echo "*** folder not found ***"
    exit 1
  fi
fi

IFS=$'\n'
for item in ${folder}/*
do
  basename "${item}"
  if [ -d ${item} ]
    then echo "${item} is folder"
  elif [ -f "${item}" ]
    then echo "${item} is file"
  fi
  echo
done

