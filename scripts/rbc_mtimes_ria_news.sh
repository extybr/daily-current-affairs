#!/bin/bash
# $> ./rbc_mtimes_ria_news.sh    # rbc.ru
# $> ./rbc_mtimes_ria_news.sh m  # moscowtimes.news
# $> ./rbc_mtimes_ria_news.sh r  # ria.ru
# Новости rbc.ru | moscowtimes.news

proxy='--proxy 127.0.0.1:1080'
source "${SCRIPTS_DIRECTORY/'~'/$HOME}"/proxy.sh 1> /dev/null

rbc_news() {
  # полупропаганда (True + False = False)
  news=$(curl -s 'https://rssexport.rbc.ru/rbcnews/news/30/full.rss' | \
         grep -oP "<title>[^/]+]" | \
         sed 's/<title><!\[CDATA\[//g ; s/]]//g')
  echo -e "\e[36m${news}\e[0m"
}

ria_rss_news() {
  # кремлевская пропаганда с интерактивными ссылками
  ria=$(curl -s 'https://ria.ru/export/rss2/archive/index.xml')
  mapfile -t title < <(echo "$ria" | grep -oP '<title>[^<]+' | sed 's/<title>//g')
  mapfile -t link < <(echo "$ria" | grep -oP '<link>[^<]+' | sed 's/<link>//g')
  for i in "${!title[@]}"; do
    printf '%3d. %b\n' $((i+1)) "\033]8;;${link[$i]}\033\\\\\033[35m${title[$i]}\033[0m\033]8;;\033\\"
  done
}

mtimes_rss_news() {
  # антипропаганда
  urls=('https://ru.themoscowtimes.com/rss/news' 'https://www.moscowtimes.news/rss/news')
  for url in "${urls[@]}"; do
    news=$(curl -s $proxy --max-time 20 --location "$url" | \
           grep -E '(title>|link>)' | \
           sed 's/<title>/\\e[36m/g ; s/<link>/\\e[0m/g ; s/<\/title>//g ; s/<\/link>//g ; s/[[:space:]]/ /g' | \
           tail +4)
    if [[ "${news}" ]]; then
      echo -e "$news" && break
    fi
  done
}

mtimes_main_page_news() {
  curl -s $proxy --location 'https://www.moscowtimes.news/news' | \
  grep -oP '(title="|\t\t\t<a href=")\K[^"]+' | \
  tail +6 | sed 'N;G' | head -n -20
}

if [ "$#" -eq 1 ] && [[ "$1" == 'm' ]]; then
  # mtimes_main_page_news
  mtimes_rss_news
elif [ "$#" -eq 1 ] && [[ "$1" == 'r' ]]; then
  ria_rss_news
else rbc_news
fi

