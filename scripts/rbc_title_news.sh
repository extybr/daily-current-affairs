#!/bin/bash

white="\e[36m"
normal="\e[0m"

rbc_news=$(curl -s 'https://rssexport.rbc.ru/rbcnews/news/30/full.rss' | \
           grep -oP "<title>[^/]+]" | \
           sed 's/<title><!\[CDATA\[//g ; s/]]//g')

echo -e "${white}${rbc_news}${normal}"

