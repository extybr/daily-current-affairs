#!/bin/bash
# $> ./cbr.sh
# Ресурсы, ссылки, курс, ставка ЦБР

bank() {
  printf "%10s" && echo -e "***** \e[34mRssPress\e[0m *****"
  curl -s 'https://www.cbr.ru/rss/RssPress' | \
  grep -oP '(<title>|<link>)\K[^<]+' | \
  sed 'N;s/\n/ /'
  
  printf "%10s" && echo -e "***** \e[34mRssNews\e[0m *****"
  curl -s 'https://www.cbr.ru/rss/RssNews' | \
  grep -oP '(<title>|<link>)\K[^<]+' | \
  head -n 20 | sed 'N;s/\n/ /'
  
  printf "%10s" && echo -e "***** \e[34mdevelopment\e[0m *****"
  curl -s 'https://www.cbr.ru/development/' | \
  grep -oP '<li class="page-nav_item">\K[^+]+</li>' | \
  grep -oP '(\-\>|")\K[^<]+' | \
  sed 's/\/development/https:\/\/www.cbr.ru\/development/g ; s/">/ 🚘 /g' | \
  sed 'N;s/\n/ /'

  printf "%10s" && echo -e "***** \e[34mRssCurrency\e[0m *****"
  currency=$(curl -s 'https://www.cbr.ru/rss/RssCurrency' | \
             grep 'Австралийский' -A 55 | \
             sed 's/pubDate>/\\033[0m/g ; s/description>/\\033[35m/g ; s/<//g; s/\///g ; s/     //g')
  IFS='\n'; for line in "$currency"; do echo -e "$line"; done
  
  printf "%10s" && echo -e "***** \e[34mCurrency\e[0m *****"
  curl -s 'https://www.cbr.ru/scripts/XML_daily.asp' | \
  iconv -f cp1251 | grep -oP '(<Name>|<Value>)\K[^<]+' | sed 'N;s/\n/ - /'
}

rate() {
  printf "%10s" && echo -e "***** \e[34mКлючевая ставка\e[0m *****"
  st=$(curl -s 'https://www.cbr.ru' | grep 'Ключевая ставка' -A 4 | tail -1 | sed 's/.*value">//')
  echo -e "Ключевая ставка ЦБР: \033[35;1m$st"
}

if [ "$#" -eq 0 ]; then
  bank
fi

rate

