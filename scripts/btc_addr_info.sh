#!/bin/bash
# $> ./btc_addr_info.sh 1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa
# Баланс биткоин кошелька

curl -s 'https://api.blockchain.info/explorer-gateway-kt/btc/address' \
  --compressed \
  -X POST \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:157.0) Gecko/20100101 Firefox/157.0' \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H 'Referer: https://www.blockchain.com/' \
  -H 'Content-Type: application/json' \
  --data-raw "{\"address\":\"$1\"}"  | jq

