#!/bin/bash

white="\e[36m"
normal="\e[0m"

source ./proxy.sh 1> /dev/null

url='https://megapeer.vip/top'
tag1='<a href=\"\/torrent'
tag2='class=\"url\">'
tag3='https:\/\/megapeer.vip\/torrent'
top_week=$(curl -s ${proxy} ${url} | \
           grep -oP "(${tag1}[^<]+|${tag2}[^<]+</a)" | \
           sed "s/${tag1}/${tag3}/g ; s/${tag2}/\\n/g")

echo -e "${white}${top_week}${normal}"

