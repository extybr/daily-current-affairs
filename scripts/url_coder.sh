#!/bin/bash
# ./url_coder.sh decoder "https%3A%2F%2Fgithub.com%2Fextybr"
# ./url_coder.sh encoder https://github.com/extybr

url_encode() {
    local LC_ALL=C
    for (( i = 0; i < ${#1}; i++ )); do
        : "${1:i:1}"
        case "$_" in
            [a-zA-Z0-9.~_-])
                printf '%s' "$_"
            ;;

            *)
                printf '%%%02X' "'$_"
            ;;
        esac
    done
    printf '\n'
}

url_decode() {
    : "${1//+/ }"
    printf '%b\n' "${_//%/\\x}"
}

if [ "$#" -ne 2 ]; then
  echo "*** Ожидалось 2 параметра ***"
  exit 1
fi

if [ "$1" = 'encoder' ]; then
  url_encode "$2"
elif [ "$1" = 'decoder' ]; then
  url_decode "$2"
fi

