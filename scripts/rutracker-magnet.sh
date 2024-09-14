#!/bin/sh

red="\e[31m"
blue="\e[36m"
normal="\e[0m"

cd ~/PycharmProjects/github/daily-current-affairs/scripts
proxy=''

if ! [ "$#" -eq 2 ]; then
  echo -e "${red} Ожидалось 2 параметра, а передано $#${normal}"
  exit 0
fi

if [ "$1" = '1' ]; then
  source ./antizapret_proxy.sh
fi

url="$2"

request=$(curl -s --location -A 'Mozilla/5.0 (X11; Linux x86_64; rv:125.0) Gecko/20100101 Firefox/125.0' ${proxy} --max-time 10 "${url}")

result=$(echo "${request}" | grep -oP 'magnet[^<]+net"' | sed 's/net"/net/g')
echo -e "\n${blue}${result}${normal}\n"

if command -v xclip > /dev/null
  then echo "${result}" | xclip -sel clip
  else echo -e "xclip: ${red}not found${normal}"
fi

