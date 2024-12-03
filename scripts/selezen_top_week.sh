#!/bin/bash

blue="\e[36m"
normal="\e[0m"

source ./proxy.sh 1> /dev/null

url='https://use.selezen.club/best-of-the-week.html'
tag1='<h6 class=\"mb-1 font-14\">'
tag2='<tr role=\"row\" class=\"cursor-pointer\" onclick=\"location.href='
top_week=$(curl -s ${proxy} ${url} | \
           grep -oP "(${tag1}[^<]+|${tag2}[^\;\"]+)" | \
           sed "s/${tag1}//g ; s/${tag2}//g")

echo -e "${blue}${top_week}${normal}"

