#!/bin/zsh
# $> ./rostelecom.sh
# lk.rt.ru | Баланс Rostelecom

RED='\033[1;31m'
GREEN='\033[1;32m'
NORM='\033[0m'
MAGENTA='\033[35m'
CYAN='\033[36m'

secret='secret.txt'
if ! [ -f "${secret}" ]; then
  echo -e "${RED} Отсутствует файл с логином и паролем ${NORM}" && exit 0
fi

source secret.txt

request=$(curl -s 'https://api.rt.ru/v2/users/current' \
          -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:143.0) Gecko/20100101 Firefox/143.0' \
          -H "${COOKIE}")

echo "$request" | jq -c | while read -r item; do
  _status=$(jq -r '.accounts.[0].status' <<< "$item")
  _id=$(jq -r '.accounts.[0].id' <<< "$item")
  phone=$(jq -r '.phone' <<< "$item")
  first_name=$(jq -r '.first_name' <<< "$item")
  last_name=$(jq -r '.last_name' <<< "$item")
  middle_name=$(jq -r '.middle_name' <<< "$item")
  client_ids=$(jq -r '.products.[].client_ids.[]' <<< "$item")
done

echo -e "${MAGENTA}${first_name} ${last_name} ${middle_name}${NORM}"
echo -e "phone: ${CYAN}${phone}${NORM}"
echo -e "id: ${CYAN}${_id}${NORM}"
echo -e "client_ids: ${CYAN}${client_ids}${NORM}"

if [ "${_status}" = 'ACTIVE' ]; then
  echo -e "status: ${GREEN}${_status}${NORM}"
else
  echo -e "status: ${RED}${_status}${NORM}"
fi

