#!/bin/bash
# $> ./bestchange.sh
# Курс обменников в текущий момент по определенной паре
# www.bestchange.com (*.ru)
# FIXME: berbank-to-usd-coin
# WARNING: не будет работать при частом использовании из-за каптчи

proxy=''
source "${SCRIPTS_DIRECTORY/'~'/$HOME}"/proxy.sh &> /dev/null

user_agent='Mozilla/5.0 (X11; Linux x86_64; rv:138.0) Gecko/20100101 Firefox/138.0'
request=$(curl -s ${proxy} -A "${user_agent}" 'https://www.bestchange.ru/sberbank-to-usd-coin.html' | iconv -f windows-1251 -t utf-8)

company=$(echo "${request}" | grep -oP 'div class="ca" translate="no">\K[^<]+')
price=$(echo "${request}" | grep -oP 'class="fs">\K[^<]+')

paste <(printf "%s\n" "${company}") <(printf "%s\n" "${price}") |
while IFS=$'\t' read -r c p; do
  printf "%s\t\033[35m%s\033[0m\n" "$c" "$p"
done | nl

