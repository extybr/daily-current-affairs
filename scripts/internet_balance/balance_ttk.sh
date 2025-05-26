#!/bin/bash
# $> ./balance_ttk.sh
# lk.ttk.ru | Баланс ТТК

source secret.txt  # содержит LOGIN и PASSWORD
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64; rv:138.0) Gecko/20100101 Firefox/138.0"
URL="https://lk.ttk.ru"
COOKIE_FILE="cookie.txt"

function session() {
  # --- Получаем новые куки и основные данные сессии ---

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
  -c "$COOKIE_FILE" | jq '.[]' 2> /dev/null) || (echo "Ошибка получения страницы логина" && exit)
  
  # --- Вывод данных ---

  contract=$(echo "$raw" | jq -r ".contract")
  stats=$(echo "$raw" | jq -r ".status")
  contract_id=$(echo "$raw" | jq -r ".contract_id")

  echo "contract: $contract"
  if [ "$stats" = 'Активен' ]; then
    echo -e "status: \033[1;32m$stats\033[0m"
  else echo -e "status: \033[1;31m$stats\033[0m"
  fi
  echo "contract_id: $contract_id"

  loginKey=$(grep 'loginKey' "$COOKIE_FILE" | awk '{print $NF}')
  sessionId=$(grep 'sessionId' "$COOKIE_FILE" | awk '{print $NF}')

  echo "loginKey: $loginKey"
  echo -e "sessionId: $sessionId\n"
  
  for var in ${loginKey} ${sessionId}; do
    if [ -z "$var" ]; then
      echo "Не получены $var" && exit
    fi
  done
  
  # --- Первый POST запрос данных в json-формате ---

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
  
  # --- Вывод данных ---

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
  
  # --- Второй POST запрос данных в json-формате ---

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
  
  # --- Вывод данных ---

  tariff=$(echo $tariff_price | jq -r '.tariff')
  price=$(echo $tariff_price | jq -r '.price')
  echo "tariff: $tariff"
  echo -e "price: \033[36m$price\033[0m"
  
  # --- Вывод истории оплат ---

  if [ "$#" -gt 0 ]; then
    days=$(( 14 * 24 * 60 * 60 ))  # 14 дней * 24 часа * 60 минут * 60 секунд
    now_date=$(date +%Y-%m-%d)  # Текущая дата
    target_date=$(date -d "@$(( $(date +%s) - days ))" +%Y-%m-%d)  # Дата на 2 недели назад

    getHistory=$(curl -s "$URL/api/payments/getHistory" -A "User-Agent: $USER_AGENT" \
    -H 'Accept: */*' -H 'Accept-Language: ru,en-US;q=0.7,en;q=0.3' \
    -H 'Accept-Encoding: gzip, deflate, br, zstd' -H "Referer: $URL/finance" \
    -H 'Content-Type: application/json' -H "Origin: $URL" -H 'Connection: keep-alive' \
    -H "Cookie: sessionId=${sessionId}; loginKey=${loginKey}; GEO_CITY_ID=8527; "\
    "GEO_CITY_CODE=komsomolsknaamure; BXMOD_AUTH_LAST_PAGE_Y=%2F" \
    -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' \
    -H 'Sec-Fetch-Site: same-origin' -H 'Sec-GPC: 1' -H 'Priority: u=4' \
    -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' \
    --data-raw "{\"contract_id\":\"${contract_id}\",\"start_date\":\"${target_date}\",\"end_date\":\"${now_date}\"}")
    
    echo -e "\n\033[36mИстория оплаты:\033[0m"
    
    echo "$getHistory" | jq -c '.[]' | while read -r item; do
      date=$(jq -r '.date' <<< "$item")
      type=$(jq -r '.type' <<< "$item")
      amount=$(jq -r '.amount' <<< "$item")
      name=$(jq -r '.name' <<< "$item")

      # Цвет по знаку суммы
      if [[ $amount == -* ]]; then
        color="\033[1;31m"     # красный
      else color="\033[1;32m"  # зелёный
      fi

      reset="\033[0m"  # Сброс цвета

      echo -e "$date | $type | ${color}${amount}${reset} | $name"  # Печать
    done

  fi
}

session "$@"

