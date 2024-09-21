#!/bin/bash
#################################
# $> ./element_in_folder.sh ~   #
#################################

if [ "$#" -ne 1 ]
  then folder="${HOME}"
else folder="$1"
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

