#!/bin/sh

cd ~/PycharmProjects/github/daily-current-affairs/scripts

if [ "$#" -eq 0 ]
  then ./rutracker.py
elif [ "$#" -eq 1 ]
  then ./rutracker.py "$1"
elif [ "$#" -eq 2 ]; then
  if ! [[ "$1" = '0' || "$1" = '1' ]]; then
    echo -e "\e[31m Первым параметром ожидалось 0 или 1\e[0m"
    exit 0
  fi
  if [ "$2" -gt 1 ] 2>/dev/null; then
    ./rutracker.py "$1" "$2"
  else ./rutracker-magnet.sh "$1" "$2"
  fi
else echo -e "\e[31m Ожидалось не более 2-х параметров, а передано $#\e[0m"
fi

