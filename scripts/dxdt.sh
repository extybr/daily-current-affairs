#!/bin/bash
# $> ./dxdt.sh
# Парсинг RSS сайта dxdt.ru

request=$(curl -s 'https://dxdt.ru/feed/' | \
          grep -E '(<title>|<link>|<pubDate>)' | \
          sed "s/<title>/\\\e[36m/g ; s/<\/title>/\\\e[0m/g ; \
          s/<link>/\\\e[33m/g ; s/<\/link>/\\\e[0m/g ; \
          s/<pubDate>/\\\e[35m/g ; s/<\/pubDate>/\\\e[0m/g ; \
          s/+0000/\n/g")

output=$(./coder_html_decimal.py "decoder" "${request}")
echo -e "${output}"

