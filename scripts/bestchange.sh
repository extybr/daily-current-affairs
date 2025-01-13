#!/bin/bash
# bestchange
# berbank-to-usd-coin

user_agent='Mozilla/5.0 (X11; Linux x86_64; rv:133.0) Gecko/20100101 Firefox/133.0'
curl -s -A "${user_agent}" 'https://www.bestchange.ru/sberbank-to-usd-coin.html' | \
grep -oP 'class="fs">[^<]+' | sed 's/^...........//'
