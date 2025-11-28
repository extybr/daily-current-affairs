#!/bin/bash
# $> ./base64.sh SGVsbG8sIFdvcmxkCg==
# $> ./base64.sh r 'Hello, World'
# Перевод строки в base64 или обратно

if [ "$#" -eq 1 ]; then
  echo "$1" | base64 -d
elif [ "$#" -eq 2 ] && [ "$1" = "r" ]; then
  echo "$2" | base64
else echo -e "*** Ожидалось 1 или 2 параметра ***\nПример:\n ./base64.sh SGVsbG8sIFdvcmxkCg==\n ./base64.sh r 'Hello, World'"
fi

