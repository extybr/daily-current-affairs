#!/bin/bash
# $> ./balance_ttk.sh    # вывод данных
# $> ./balance_ttk.sh 1  # вывод данных с историей оплаты
# lk.ttk.ru | Баланс ТТК

source secret.txt  # содержит LOGIN и PASSWORD
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64; rv:138.0) Gecko/20100101 Firefox/138.0"
URL="https://lk.ttk.ru"
COOKIE_FILE="cookie.txt"

function session() {

  # --- Цвета ---
  
  red='\033[1;31m'
  green='\033[1;32m'
  norm='\033[0m'
  magenta='\033[35m'
  cyan='\033[36m'

  # --- Параметры curl ---
  
  COMMON_HEADERS=(
  -A "User-Agent: $USER_AGENT"
  -H 'Accept: */*'
  -H 'Accept-Language: ru,en-US;q=0.7,en;q=0.3'
  -H 'Accept-Encoding: gzip, deflate, br, zstd'
  -H 'Content-Type: application/json'
  -H "Origin: $URL"
  -H 'Connection: keep-alive'
  -H 'Sec-Fetch-Dest: empty'
  -H 'Sec-Fetch-Mode: cors'
  -H 'Sec-Fetch-Site: same-origin'
  -H 'Sec-GPC: 1'
  -H 'Priority: u=4'
  -H 'Pragma: no-cache'
  -H 'Cache-Control: no-cache'
)

  # --- Получаем новые куки и основные данные сессии ---

  raw=$(curl -s --fail "$URL/api/auth/loginByAccount" \
  -c "$COOKIE_FILE" -b "$COOKIE_FILE" \
  -H "Referer: $URL/auth" "${COMMON_HEADERS[@]}" \
  --data-raw "{\"login\":\"$LOGIN\",\"password\":\"$PASSWORD\",\"remember\":false}" \
  -c "$COOKIE_FILE" | jq '.[]' 2> /dev/null) || (echo "Ошибка получения страницы логина" && exit)
  
  # --- Вывод данных ---
  
  contract=$(jq -r '.contract' <<< "$raw")
  status=$(jq -r '.status' <<< "$raw")
  contract_id=$(jq -r '.contract_id' <<< "$raw")

  echo "contract: $contract"
  if [ "$status" = 'Активен' ]; then
    echo -e "status: ${green}${status}${norm}"
  else
    echo -e "status: ${red}${status}${norm}"
  fi
  echo "contract_id: $contract_id"

  loginKey=$(awk '/loginKey/ {print $NF}' "$COOKIE_FILE" 2>/dev/null)
  sessionId=$(awk '/sessionId/ {print $NF}' "$COOKIE_FILE" 2>/dev/null)

  echo "loginKey: $loginKey"
  echo -e "sessionId: $sessionId\n"
  
  for attempt in {1..2}; do
    if [[ -z "$loginKey" || -z "$sessionId" ]]; then
      echo -e "Не получены ${red}loginKey, sessionId${norm}"
      (( attempt == 2 )) && exit
      sleep 2
      session
    else
      break
    fi
  done

  # --- Первый POST запрос данных в json-формате ---

  info=$(curl -s --fail "$URL/api/user" \
  -H "Referer: $URL/" "${COMMON_HEADERS[@]}" \
  -H "Cookie: sessionId=${sessionId}; loginKey=${loginKey}" \
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
  echo -e "balance: ${magenta}${balance}${norm}\n"
  
  # --- Второй POST запрос данных в json-формате ---

  tariff_price=$(curl -s --fail "$URL/api/services/getServices" \
  -H "Referer: $URL/" "${COMMON_HEADERS[@]}" \
  -H "Cookie: sessionId=${sessionId}; loginKey=${loginKey}" \
  --data-raw "{\"contract_id\":\"${contract_id}\"}" | jq -r ".[]" 2> /dev/null)
  
  # --- Вывод данных ---

  tariff=$(echo $tariff_price | jq -r '.tariff')
  price=$(echo $tariff_price | jq -r '.price')
  echo "tariff: $tariff"
  echo -e "price: ${cyan}${price}${norm}"
  
  # --- Вывод истории оплат ---

  if [[ "$#" -gt 0 ]]; then
    days=$(( 14 * 24 * 60 * 60 ))  # 14 дней * 24 часа * 60 минут * 60 секунд
    now_date=$(date +%Y-%m-%d)  # Текущая дата
    target_date=$(date -d "@$(( $(date +%s) - days ))" +%Y-%m-%d)  # Дата на 2 недели назад

    getHistory=$(curl -s --fail "$URL/api/payments/getHistory" \
    -H "Referer: $URL/finance" "${COMMON_HEADERS[@]}" \
    -H "Cookie: sessionId=${sessionId}; loginKey=${loginKey}; GEO_CITY_ID=8527; "\
    "GEO_CITY_CODE=komsomolsknaamure; BXMOD_AUTH_LAST_PAGE_Y=%2F" \
    --data-raw "{\"contract_id\":\"${contract_id}\",\"start_date\":\"${target_date}\",\"end_date\":\"${now_date}\"}")
    
    echo -e "\n${cyan}История оплаты:${norm}"
    
    echo "$getHistory" | jq -c '.[]' | while read -r item; do
      date=$(jq -r '.date' <<< "$item")
      type=$(jq -r '.type' <<< "$item")
      amount=$(jq -r '.amount' <<< "$item")
      name=$(jq -r '.name' <<< "$item")

      # Цвет по знаку суммы
      if [[ $amount == -* ]]; then
        color="${red}"
      else color="${green}"
      fi

      echo -e "$date | $type | ${color}${amount}${norm} | $name"  # Печать
    done

  fi
}

session "$@"

