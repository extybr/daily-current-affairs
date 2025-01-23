#!/bin/bash
####################################
# $> ./dig_drill_ip.sh rutor.info  #
####################################
# HACK: IP address determination tracing blocked and not blocked IP addresses

blue="\033[36m"
red='\033[31m'
normal="\033[0m"

if [ $# -ne 1 ]; then
  echo -e " ${red}1${normal} parameter was expected, but ${red}$#${normal} were passed"
  exit 0
fi

check() {
  if ! test "${ip_addr}"; then
    echo -e " ${blue}$1${normal}: ip address ${red}not found${normal}"
    exit 0
  fi
}

cmd_nslookup() {
  request=$(timeout 3 nslookup "$1")
  if [ "$?" = '124' ]; then
    echo 'timeout'
    cmd_nslookup "$1"
  else ip_addr=$(echo "${request}" | grep 'Address:' | grep -v '192.168.' | cut -d " " -f 2)
  fi
}

cmd_drill() {
  request=$(timeout 3 drill "$1" -T @8.8.8.8 2> /dev/null)
  if [ "$?" = '124' ]; then
    echo 'timeout'
    cmd_drill "$1"
  else ip_addr=$(echo "${request}" | grep -E "^$1" | grep -w 'A' | tr -d '\t' | cut -d 'A' -f 2)
  fi
}

cmd_dig() {
  request=$(timeout 3 dig +trace "$1" @8.8.8.8)
  if [ "$?" = '124' ]; then
    echo 'timeout'
    cmd_dig "$1"
  else ip_addr=$(echo "${request}" | grep -E "^$1" | grep -w 'A' | tr -d '\t' | cut -d 'A' -f 2)
  fi
}

if command -V dig &> /dev/null; then
  cmd_dig "$1"
  check "$1" "${ip_addr}"
elif command -V drill &> /dev/null; then
  cmd_drill "$1"
  check "$1" "${ip_addr}"
elif command -V nslookup &> /dev/null; then
  cmd_nslookup "$1"
  check "$1" "${ip_addr}"
else echo -e "command ${blue}dig${normal}, ${blue}drill${normal} and ${blue}nslookup${normal} ${red}not found${normal}"
  exit 0
fi

IFS=$'\n'
for word in ${ip_addr}
do
  if [ $(echo "${word}" | wc -w) = '1' ]; then
    echo -e "${blue}${word}${normal}"
  fi
done

