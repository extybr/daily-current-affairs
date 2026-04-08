#!/bin/bash
# $> ./onlyin.sh file1.txt file2.txt
# Поиск уникальных строк в двух файлах

if [ "$#" -ne 2 ]; then
  echo '*** Ожидалось 2 файла ***' && exit
fi

file1="$1"
file2="$2"

util_awk() {
  awk 'NR==FNR {a[$0]; next} !($0 in a)' "$1" "$2"
}

util_grep() {
  grep -Fxvf "$1" "$2"
}

util_comm() {
  comm -13 <(sort "$2") <(sort "$1")
}

util_comm_uniq() {
  comm -23 <(sort -u "$1") <(sort -u "$2")
}

# util_awk $1 $2
# util_grep $1 $2
# util_comm $1 $2
echo -e '\n******** file1 vs file2 ********\n' && util_comm_uniq $1 $2 && \
echo -e '\n******** file2 vs file1 ********\n' && util_comm_uniq $2 $1

