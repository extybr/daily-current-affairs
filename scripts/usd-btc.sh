#!/bin/sh
######################
# $> ./usd-btc.sh    #
######################

WHITE="\033[37m"
YELLOW="\033[1;33m"
NORMAL="\033[0m"

user_agent="Mozilla/5.0 (X11; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0"

date +%c

start=$(date +"%Y-%m-%d %H:%M:%S")
start_timestamp=$(date -d "${start}" +%s)

#BTC=$(curl -s https://api.binance.com/api/v1/ticker/24hr | jq -r ".[11].lastPrice"); echo "BTC = $BTC $"
BTC=$(curl -s --max-time 10 -A "${user_agent}" 'https://api.binance.com/api/v1/ticker/24hr' | \
jq -r '.[] | select(.symbol == "BTCUSDT")' 2>/dev/null | jq -r ".lastPrice")
echo -e "${YELLOW}BTC${NORMAL} = ${WHITE}${BTC}${NORMAL} $"

EUR=$(curl -s --max-time 5 -A "${user_agent}" 'https://www.cbr-xml-daily.ru/daily_json.js' | \
jq -r ".Valute.EUR.Value")
echo -e "${YELLOW}EUR${NORMAL} = ${WHITE}${EUR}${NORMAL} RUB"

#USD=$(curl -s https://www.cbr-xml-daily.ru/latest.js | jq -r ".rates.USD"); echo $((1 / "$USD"))
USD=$(echo "scale = 10; 1/$(curl -s --max-time 5 -A "${user_agent}" 'https://www.cbr-xml-daily.ru/latest.js' | \
jq -r ".rates.USD")" | bc)
echo -e "${YELLOW}USD${NORMAL} = ${WHITE}${USD}${NORMAL} RUB"

end=$(date +"%Y-%m-%d %H:%M:%S")
end_timestamp=$(date -d "${end}" +%s)

echo "Время ожидания: $(("${end_timestamp}" - "${start_timestamp}"))s"

