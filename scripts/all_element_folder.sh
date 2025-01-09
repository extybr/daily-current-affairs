#!/bin/bash
################################
# $> ./all_element_size.sh ~   #
################################

path="$1"

if ! test -d "${path}": then
  echo "*** folder not found ***"
  exit 1
fi

IFS=$'\n'
for item in $(ls -A ${path} | tr -d "\t")
  do
    if [ -d ${path}/${item} ]; then echo "${item} is folder"
    elif [ -f ${path}/${item} ]; then echo "${item} is file"; fi
    echo
  done

