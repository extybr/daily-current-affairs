#!/bin/bash
# $> ./rbc_mtimes_news.sh    # rbc.ru
# $> ./rbc_mtimes_news.sh m  # moscowtimes.news
# Новости rbc.ru | moscowtimes.news

PROXY='--proxy 127.0.0.1:1080'

rbc_news() {
  news=$(curl -s 'https://rssexport.rbc.ru/rbcnews/news/30/full.rss' | \
         grep -oP "<title>[^/]+]" | \
         sed 's/<title><!\[CDATA\[//g ; s/]]//g')
  echo -e "\e[36m${news}\e[0m"
}

mtimes_rss_news() {
  news=$(curl -s $PROXY 'https://www.moscowtimes.news/rss/news' | \
         grep -E '(title>|link>)' | \
         sed 's/<title>/\\e[36m/g ; s/<link>/\\e[0m/g ; s/<\/title>//g ; s/<\/link>//g ; s/[[:space:]]/ /g' | \
         tail +4)
  echo -e "$news"
}

mtimes_main_page_news() {
  curl -s $PROXY 'https://www.moscowtimes.news/news' | \
  grep -oP '(title="|\t\t\t<a href=")\K[^"]+' | tail +6 | sed 'N;G' | head -n -20
}

if [ "$#" -eq 1 ] && [[ "$1" = m ]]; then
  # mtimes_main_page_news
  mtimes_rss_news
else rbc_news
fi

