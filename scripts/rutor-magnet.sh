#!/bin/sh

##############################################################
# Example:                                                   #
# $> ./rutor-magnet.sh 0 'http://rutor.info/torrent/999364'  #
# $> ./rutor-magnet.sh 1 'http://rutor.info/torrent/999364'  #
##############################################################

BLUE="\e[36m"
RED="\e[31m"
NORM="\e[0m"

current_folder=$(pwd)
cd ~/PycharmProjects/github/daily-current-affairs/scripts
proxy=''

if [ "$1" = '1' ]; then
  source ./antizapret_proxy.sh
fi

url="$2"

rutor() {
request=$(curl -s ${proxy} --max-time 5 "${url}" | grep -oP 'magnet[^<]+ce' | grep amp)
echo -e "\n${BLUE}${request}${NORM}\n"
if command -v xclip > /dev/null
  then echo "${request}" | xclip -sel clip
  else echo -e "xclip: ${RED}not found${NORM}"
fi
}

rutor

