#!/bin/bash
# $> ./hashcat_brute.sh ef2d127de37b942baad0614

set -e

HASH=''
HASH_MODE=1400  # Для примера и изменения в функцию brutePassword
HASH_NAME='sha256'  # Для примера в функцию inputPassword
HASH_SEARCH='\$6\$'  # Для примера в функцию helpHashcat

function helpHashcat {
  # https://hashcat.net/wiki/doku.php?id=example_hashes
  hashcat --example | rg "${HASH_SEARCH}" -B 10 -A 10
  hashcat --help | rg SHA1
}

function inputPassword {
  read -sp "Введите пароль: " passin
  HASH=$(echo -n "${passin}" | "${HASH_NAME}"sum 2> /dev/null)
  HASH="${HASH:0:-3}"
}

function brutePassword {
  echo -e "\nХэш: ${HASH}"
  echo "Длина хэша: $(expr length "${HASH}")"
  hashcat -m "${HASH_MODE}" "${HASH}" -a 3 -w 3 '?d?d?d' &> /dev/null
  hash_pass=$(hashcat -m 1400 "${HASH}" --show)
  echo "Пароль: ${hash_pass#*:}"
}

if [ "$#" -eq 1 ]; then
    HASH="$1"
  else echo "*** Не найден хэш ***" &&  inputPassword
fi

# helpHashcat
brutePassword

