#!/bin/bash
# $> ./rss-news-kmscity.sh
# Новости администрации komcity + rss

news() {
  curl -s 'https://www.kmscity.ru/rss-feeds/news.rss' | \
  grep -oP '(<title>|<link>)\K[^<]+' | tail -n +3 | \
  xargs -d '\n' -n2 printf "\033[36m%s \033[32m  \033[35m%s\033[0m\n"
}

rss_v1() {
  curl -s 'https://www.kmscity.ru/rss-feeds/' | \
    grep -oP 'href="\K[^"]+\.rss[^<]*' | \
    awk -F'">' '{
      sub(/^\/rss/, "https://www.kmscity.ru/rss", $1);
      printf "\033[36m%s \033[35m%s\n", $2, $1
    }'
}

rss_v2() {
  curl -s 'https://www.kmscity.ru/rss-feeds/' | \
  grep -oP 'href="\K[^"]+\.rss[^<]*' | \
  sed 's/">/ | /g ; s/\/rss/|https:\/\/www.kmscity.ru\/rss/g' | \
  xargs -d '|' -n2 printf "\033[36m%s \033[35m%s"
}

rss_v3() {
  curl -s 'https://www.kmscity.ru/rss-feeds/' | \
  # Ищем ссылки на RSS + текст после них
  grep -oP 'href="\K[^"]+\.rss[^<]*' | \
  # Форматируем
  sed -E 's|">| |; s|^/rss|https://www.kmscity.ru/rss|' | \
  # Разбиваем на две переменные
  while read -r title url; do \
    printf '\033[36m%s \033[35m%s\n' "$title" "$url"  # Вывод с цветами
  done
}

if [ "$#" -gt 0 ]; then
  rss_v1
else news
fi

