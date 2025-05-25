#!/bin/bash
# $> ./balance_ttk.sh
# lk.ttk.ru | Баланс ТТК

source secret.txt  # содержит LOGIN и PASSWORD
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64; rv:138.0) Gecko/20100101 Firefox/138.0"
URL="https://lk.ttk.ru"
COOKIE_FILE="cookie.txt"

function session() {
  raw=$(curl -s "$URL/api/auth/loginByAccount" -A "User-Agent: $USER_AGENT" \
  -c "$COOKIE_FILE" -b "$COOKIE_FILE" --fail -H 'Accept: */*' \
  -H 'Accept-Language: ru,en-US;q=0.7,en;q=0.3' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H "Referer: $URL/auth" -H 'Content-Type: application/json' \
  -H "Origin: $URL" -H 'Connection: keep-alive' -H 'Sec-Fetch-Dest: empty' \
  -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-GPC: 1' -H 'Priority: u=0' -H 'Pragma: no-cache' \
  -H 'Cache-Control: no-cache' \
  --data-raw "{\"login\":\"$LOGIN\",\"password\":\"$PASSWORD\",\"remember\":false}" \
  -c "$COOKIE_FILE" | jq '.[]' 2> /dev/null) || { echo "Ошибка получения страницы логина"; }
  
  contract=$(echo "$raw" | jq -r ".contract")
  stats=$(echo "$raw" | jq -r ".status")
  contract_id=$(echo "$raw" | jq -r ".contract_id")
  
  echo "contract: $contract"
  echo "status: $stats"
  echo "contract_id: $contract_id"

  loginKey=$(grep 'loginKey' "$COOKIE_FILE" | awk '{print $NF}')
  sessionId=$(grep 'sessionId' "$COOKIE_FILE" | awk '{print $NF}')

  echo "loginKey: $loginKey"
  echo -e "sessionId: $sessionId\n"
  
  info=$(curl -s --fail "$URL/api/user" -A "User-Agent: $USER_AGENT" -H 'Accept: */*' \
  -H 'Accept-Language: ru,en-US;q=0.7,en;q=0.3' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H "Referer: $URL/" -H 'Content-Type: application/json' \
  -H "Origin: $URL" -H 'Connection: keep-alive' \
  -H "Cookie: sessionId=${sessionId}; loginKey=${loginKey}" \
  -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: same-origin' -H 'Sec-GPC: 1' -H 'Priority: u=4' \
  -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' \
  --data-raw "{\"contract_id\":\"${contract_id}\"}" | jq 2> /dev/null)
  
  last_name=$(echo "$info" | jq -r '.last_name')
  first_name=$(echo "$info" | jq -r '.first_name')
  middle_name=$(echo "$info" | jq -r '.middle_name')
  echo "name: $last_name $first_name $middle_name"
  address=$(echo "$info" | jq -r '.address')
  echo "address: $address"
  login=$(echo "$info" | jq -r '.login')
  echo "login: $login"
  balance=$(echo "$info" | jq -r '.balance')
  echo -e "balance: \033[35m$balance\033[0m\n"
  
  tariff_price=$(curl -s --fail "$URL/api/services/getServices" -A "User-Agent: $USER_AGENT" \
  -H 'Accept: */*' -H 'Accept-Language: ru,en-US;q=0.7,en;q=0.3' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H "Referer: $URL/" -H 'Content-Type: application/json' \
  -H "Origin: $URL" -H 'Connection: keep-alive' \
  -H "Cookie: sessionId=${sessionId}; loginKey=${loginKey}" \
  -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Site: same-origin' -H 'Sec-GPC: 1' \
  -H 'Priority: u=4' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' \
  --data-raw "{\"contract_id\":\"${contract_id}\"}" | jq -r ".[]" 2> /dev/null)
  
  tariff=$(echo $tariff_price | jq -r '.tariff')
  price=$(echo $tariff_price | jq -r '.price')
  echo "tariff: $tariff"
  echo -e "price: \033[36m$price\033[0m"
}

session

