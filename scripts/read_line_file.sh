#!/bin/bash
# $> ./read_line_file.sh
# TODO: замена пути файла для чтения

IFS=$'\n'
for var in $(cat "${HOME}/.bash_history")
do
  echo "${var}"
done

##############################

for var in $(< ~/.bash_history)
do
  echo "${var}"
done

##############################

while read line; do
  echo "$line"
done < ~/.bash_history

##############################

