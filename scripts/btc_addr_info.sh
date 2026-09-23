#!/bin/bash
# $> ./btc_addr_info.sh 1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa
# Баланс биткоин кошелька

curl 'https://api.blockchain.info/explorer-gateway-kt/btc/address' \
  --compressed \
  -X POST \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:156.0) Gecko/20100101 Firefox/156.0' \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H 'Referer: https://www.blockchain.com/' \
  -H 'Content-Type: application/json' \
  -H 'Origin: https://www.blockchain.com' \
  -H 'Connection: keep-alive' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: cross-site' \
  -H 'Sec-GPC: 1' \
  -H 'Pragma: no-cache' \
  -H 'Cache-Control: no-cache' \
  -H 'TE: trailers' \
  --data-raw "{\"address\":\"$1\"}"  # | jq

