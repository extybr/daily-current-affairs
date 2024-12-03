#!/bin/bash

blue="\e[36m"
normal="\e[0m"

echo -e "\e[36;1mhttps://www.python.org/ftp/python/${normal}\n"

IFS=$'\n'
html=$(curl -s 'https://www.python.org/downloads/feed.rss')
date=($(echo "${html}" | grep -oP 'Release date:[^<]+' | sed 's/+00:00//g'))
version=($(echo "${html}" | grep -oP '<link>[^<]+' | tail +2 | sed 's/<link>//g'))
for i in {0..9}; do
  echo -e "${date[$i]}\n${blue}${version[$i]}${normal}"
done
