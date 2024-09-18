#!/bin/bash

violet="\e[35m"
blue="\e[36m"
yellow="\e[33m"
normal="\e[0m"

request() {
result=$(curl -s 'https://ru.tradingview.com/markets/indices/quotes-major/' | grep -oP '{"s":"SP:SPX"[^>]+"tot' | sed 's/],"tot//g ; s/},{"s"/}{"s"/g')
IFS=$'\n'
for line in "${result}"
do 
index=($(echo $line | jq -r '.s'))
title=($(echo $line | jq -r '.d[1]'))
value=($(echo $line | jq -r '.d[6]'))

done
}

request

for number in {0..24}; do
echo -e "${blue}${index[${number}]}${normal}  ${violet}${title[${number}]}${normal}  ${yellow}${value[${number}]}${normal}"
done
