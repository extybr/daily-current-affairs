#!/bin/bash
######################
# $> ./usd-btc.sh    #
######################

WHITE="\033[37m"
YELLOW="\033[1;33m"
NORMAL="\033[0m"

user_agent="Mozilla/5.0 (X11; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0"

date +%c

start_ts=$(date +%s)

src() {
VALUE=$(curl -s --max-time 5 -A "${user_agent}" "$1" | jq -r "$2" 2> /dev/null)
}

src 'https://api.binance.com/api/v1/ticker/24hr' '.[] | select(.symbol == "BTCUSDT")'
if [[ "${VALUE}" ]]; then
  VALUE=$(echo "${VALUE}" | jq -r ".lastPrice" | awk '{printf("%.4f",$1)}')
else src 'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD' '.USD'
  if [[ "${VALUE}" ]]; then
    true
  else src 'https://api.coindesk.com/v1/bpi/currentprice/USD.json' '.bpi.USD.rate'
  fi
fi
echo -e "${YELLOW}BTC${NORMAL} = ${WHITE}${VALUE}${NORMAL} $"

src 'https://www.cbr-xml-daily.ru/daily_json.js' '.Valute.EUR.Value'
echo -e "${YELLOW}EUR${NORMAL} = ${WHITE}${VALUE}${NORMAL} RUB"

src 'https://www.cbr-xml-daily.ru/latest.js' '.rates.USD'
echo -e "${YELLOW}USD${NORMAL} = ${WHITE}$(echo "scale=4; 1/${VALUE}" | bc)${NORMAL} RUB"

end_ts=$(date +%s)

echo "Время ожидания: $(("${end_ts}" - "${start_ts}"))s"

