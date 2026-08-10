#!/bin/bash
########################################
# $> ./dig_drill_ip.sh rutor.info      #
# $> ./dig_drill_ip.sh rutor.info more #
########################################
# HACK: IP address determination tracing blocked and not blocked IP addresses

blue="\033[36m"
red='\033[31m'
normal="\033[0m"

opencck() {
  curl -s "https://iplist.opencck.org/?format=json&site=$1" | jq
}

if [ "$#" -eq 2 ]; then
  opencck "$1" && exit 0
fi

if [ "$#" -ne 1 ]; then
  echo -e " ${red}1 or 2${normal} parameter was expected, but ${red}$#${normal} were passed"
  echo " Example:"
  echo -e "  ${blue}./dig_drill_ip.sh rutor.info"
  echo -e "  ./dig_drill_ip.sh rutracker.org more"
  echo -e "  ./dig_drill_ip.sh youtube.com m | less"
  echo -e "  ./dig_drill_ip.sh x.com m | more${normal}"
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
  else ip_addr=$(echo "${request}" | grep 'Address:' | grep -vE '(192|127)' | awk '{print $2}')
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
  # timeout 3 dig +trace "$1" @8.8.8.8 | grep -E "^$1" | grep -w 'A' | tr -d '\t' | cut -d 'A' -f 2  # long time
  request=$(timeout 3 dig +nocmd +noall +answer "$1")
  if [ "$?" = '124' ]; then
    echo 'timeout'
    cmd_dig "$1"
  else ip_addr=$(echo "${request}" | awk '{print $5}')
  fi
}

if command -v dig &> /dev/null; then
  cmd_dig "$1"
elif command -v drill &> /dev/null; then
  cmd_drill "$1"
elif command -v nslookup &> /dev/null; then
  cmd_nslookup "$1"
else echo -e "command ${blue}dig${normal}, ${blue}drill${normal} and ${blue}nslookup${normal} ${red}not found${normal}"
  exit 0
fi

check_err() {
  for addr in $1; do
    if ! [[ $(echo "${addr}" | wc -w) -eq 1 ]]; then
      echo -e "${red}errors${normal}" && exit 1
    fi
  done
}

check "$1" "${ip_addr}" && check_err "${addr}" && echo -e "${blue}${ip_addr}"

