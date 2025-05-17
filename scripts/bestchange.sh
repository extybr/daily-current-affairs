#!/bin/bash
# $> ./bestchange.sh
# Курс обменников в текущий момент по определенной паре
# www.bestchange.com (*.ru)
# FIXME: по определенным ссылкам
# WARNING: не будет работать при частом использовании из-за каптчи

set -e

proxy=''
source "${SCRIPTS_DIRECTORY/'~'/$HOME}"/proxy.sh &> /dev/null

urls=('https://www.bestchange.ru/tinkoff-to-tether-erc20.html' \
'https://www.bestchange.ru/sberbank-to-tether-erc20.html' \
'https://www.bestchange.ru/sberbank-to-usd-coin.html')

if [ "$#" -eq 1 ] && [ "$1" -gt 0 ] && [ "$1" -le 3 ]; then
  url="${urls[$(( $1 - 1 ))]}"
  echo -e "\033[35m${url}\033[0m\n"
else echo -e "  Доступные параметры (цифры от 1 до 3)\033[36m" \
     && echo -e "${urls[@]}\033[0m" | sed 's/ /\n/g' | nl && exit
fi

user_agent='Mozilla/5.0 (X11; Linux x86_64; rv:138.0) Gecko/20100101 Firefox/138.0'
request=$(curl -s --max-time 10 ${proxy} -A "${user_agent}" "${url}" | \
          iconv -f windows-1251 -t utf-8)

company=$(echo "${request}" | grep -oP 'div class="ca" translate="no">\K[^<]+')
price=$(echo "${request}" | grep -oP 'class="fs">\K[^<]+')

paste <(printf "%s\n" "${company}") <(printf "%s\n" "${price}") | \
awk '{ printf "\033[36m%-16s  \033[35m%s\033[0m\n", $1, $2 }' | nl

