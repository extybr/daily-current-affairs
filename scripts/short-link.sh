#!/bin/sh
# $> ./short-link.sh t.me/extybr_bot
# Создание короткой ссылки

yellow="\033[33m"
normal="\033[0m"

if [ "$#" -ne 1 ]; then 
  echo -e "${yellow}Ожидалось 1 параметр, а передано $#${normal}"
  exit 0
fi

link=$(echo "$1" | sed "s/https:\/\///g")
curl -F url="https://${link}" "https://shorta.link"

