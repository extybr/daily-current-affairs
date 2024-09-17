#!/bin/sh

violet="\e[35m"
blue="\e[36m"
yellow="\e[33m"
red="\e[31m"
normal="\e[0m"

if [ "$#" -ne 2 ]; then echo -e "${red}*** Ожидалось 2 параметра, а передано $# ***"${normal}; exit 0; fi
proxy=''
if [ "$1" -eq 1 ]; then source ./antizapret_proxy.sh; fi
name=$(echo "$2" | sed 's/ /+/g')

request() {
user_agent='Mozilla/5.0 (X11; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0'
html=$(curl -s ${proxy} -A "${user_agent}" --max-time 10 "https://bitsearch.to/search?q=${name}&sort=date")
if ! [[ "${html}" ]]; then request; fi
}

request
magnets=($(echo "${html}" | grep -oP 'magnet:?[^>]+" data' | sed 's/" data//g'))
links=($(echo "${html}" | grep -oP '<a href="/torrents/[^>]+" data' | sed 's/<a href="/https:\/\/bitsearch.to/g ; s/" data//g'))
word='%5BBitsearch.to%5D'

uri() {
echo "$1" | sed "s/+/ /g ; s/%C2%AE/®/g ; s/%20/ /g ; s/%21/\!/g ; s/%22/\"/g ; s/%23/#/g ; s/%24/$/g ; s/%25/%/g ; s/%26/&/g ; s/%27/'/g ; s/%28/(/g ; s/%29/)/g ; s/%2A/*/g ; s/%2B/+/g ; s/%2C/,/g ; s/%2F/\//g ; s/%3A/:/g ; s/%3B/;/g ; s/%3D/=/g ; s/%3F/?/g ; s/%40/@/g ; s/%5B/[/g ; s/%5D/]/g ; s/&#x3D;/=/g ; s/amp;//g"
}

output() {
for item in {0..20}; do
  magnet=$(echo "${magnets[$item]}")
  link=$(echo "${links[$item]}")
  if [[ "${magnet}" ]]; then
    title=$(uri ${magnet#*"$word"})
    uri_magnet=$(uri "${magnet}")
    echo -e "${yellow}${title}${normal}\n${violet}${link}${normal}\n${blue}${uri_magnet}${normal}\n"
  fi
done
}

output

