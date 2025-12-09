#!/bin/bash
# $> ./cbr.sh
# Ресурсы, ссылки, курс, ставка ЦБР

curl -s 'https://www.cbr.ru/rss/RssPress' | grep -oP '(<title>|<link>)\K[^<]+' | sed 'N;s/\n/ /'
echo
curl -s 'https://www.cbr.ru/rss/RssNews' | grep -oP '(<title>|<link>)\K[^<]+' | head -n 20 | sed 'N;s/\n/ /'
echo

curl -s 'https://www.cbr.ru/development/' | \
grep -oP '<li class="page-nav_item">\K[^+]+</li>' | \
grep -oP '(\-\>|")\K[^<]+' | \
sed 's/\/development/https:\/\/www.cbr.ru\/development/g ; s/">/ 🚘 /g' | \
sed 'N;s/\n/ /'

echo
curl -s 'https://www.cbr.ru/rss/RssCurrency' | grep 'Австралийский' -A 55
echo
curl -s 'https://www.cbr.ru/scripts/XML_daily.asp' | iconv -f cp1251 | grep -oP '(<Name>|<Value>)\K[^<]+' | sed 'N;s/\n/ - /'
echo
echo -e "Ключевая ставка ЦБР: \033[35;1m$(curl -s 'https://www.cbr.ru' | grep 'Ключевая ставка' -A 4 | tail -1 | sed 's/.*value">//g')"

