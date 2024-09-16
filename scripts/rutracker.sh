#!/bin/sh

cd ~/PycharmProjects/github/daily-current-affairs/scripts

if [ "$#" -eq 0 ]
  then ./rutracker.py
elif [ "$#" -eq 2 ]
  then ./rutracker-magnet.sh "$1" "$2"
else echo -e "\e[31m Ожидалось 0 или 2 параметра, а передано $#\e[0m"
fi

