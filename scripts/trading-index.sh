#!/bin/sh

get() {
result=$(curl -s 'https://ru.tradingview.com/markets/indices/quotes-major/' | grep -oP '{"s":"SP:SPX"[^>]+"tot' | sed 's/],"tot//g ; s/},{"s"/}{"s"/g')
IFS=$'\n'
for line in "${result}"
do 
index=$(echo $line | jq -r '.s')
title=$(echo $line | jq -r '.d[1]')
value=$(echo $line | jq -r '.d[6]')
paste -d ' | ' <(echo "${index}") <(echo "${title}") <(echo "${value}")
done
}

IFS=$' | '
echo $(get) | while read item; do
echo -e "[*] ${item}"
done

