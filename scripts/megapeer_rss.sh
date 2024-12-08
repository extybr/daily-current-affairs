#!/bin/bash
# $> ./megapeer_rss.sh

blue="\\\e[36m"
violet="\\\e[35m"
normal="\e[0m"

source ./proxy.sh 1> /dev/null

src='https://megapeer.vip/rss'
tag1='<title>'
tag2='<link>'
tag3='<\/title>'
tag4='<\/link>'

html=$(curl -s ${proxy} ${src})
rss=$(echo "${html}" | iconv -f cp1251 | grep "${tag1}" -A 1 | tail +6 | \
      sed "s/${tag1}/${blue}/g ; s/${tag2}/${violet}/g ; s/${tag3}//g ; s/${tag4}//g ; s/--//g")

echo -e "${rss}${normal}"

