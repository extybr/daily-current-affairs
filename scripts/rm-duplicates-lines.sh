#!/bin/bash
# $> ./rm-duplicates-lines.sh file.txt
# Removing duplicate lines from a file / Удаление дубликатов строк с файла

if [ "$#" -ne 1 ]; then
  echo '*** One parameter was expected ***' && exit 1
fi

filename="$1"

content=$(awk '!a[$0]++' "$filename")
echo "$content" > "$filename"

