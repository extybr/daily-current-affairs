#!/bin/bash
# $> ./bestchange.sh
# Курс обменников в текущий момент по определенной паре
# www.bestchange.com (*.ru)
# FIXME: berbank-to-usd-coin
# WARNING: не будет работать при частом использовании из-за каптчи

source ./proxy.sh &> /dev/null

user_agent='Mozilla/5.0 (X11; Linux x86_64; rv:133.0) Gecko/20100101 Firefox/133.0'
curl -s ${proxy} -A "${user_agent}" 'https://www.bestchange.ru/sberbank-to-usd-coin.html' | \
grep -oP 'class="fs">[^<]+' | sed 's/^...........//'

