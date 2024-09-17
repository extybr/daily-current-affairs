#!/bin/sh
###################################################################################
# $> ./1337x.sh 1 'Taylor Swift'                                                  #
# $> ./1337x.sh 1 'https://1337x.to/torrent/6213094/J-R-Rain-The-Lost-Ark-azw3/'  #
###################################################################################

blue="\e[36m"
red="\e[31m"
normal="\e[0m"

cd ~/PycharmProjects/github/daily-current-affairs/scripts

if [ "$#" -ne 2 ]; then echo -e "${red}*** ожидалось 2 параметра, а передано $# ***${normal}"; exit 0; fi
proxy="--proxy n.thenewone.lol:29976"
if [ "$1" = '1' ]; then source ./antizapret_proxy.sh
elif [ "$1" = '0' ]; then proxy=''
fi

name=$(echo "$2" | sed 's/ /%20/g')
user_agent="Mozilla/5.0 (X11; Linux x86_64; rv:125.0) Gecko/20100101 Firefox/128.0"

request() {
html=$(curl -s "https://1337x.to/sort-search/"${name}"/time/desc/1/" ${proxy} -A "${user_agent}")
result=$(echo "${html}" | grep -oP '/torrent/[^<]+</a' | sed "s/\/torrent/https:\/\/1337x.to\/torrent/g ; s/\/\">/\/\n/g ; s/<\/a/\n/g")
echo -e "${blue}${result}${normal}"
}

search() {
html=$(curl -s "${name}" ${proxy} -A "${user_agent}")
result=$(echo "${html}" | grep -oP 'magnet[^>]+nce' | head -n 1)
echo -e "\n${blue}${result}${normal}\n"
if command -v xclip > /dev/null
  then echo "${result}" | xclip -sel clip
  else echo -e "xclip: ${red}not found${normal}"
fi
}

if [ ${name%'1337x.to'*} = 'https://' ]; then search; else request; fi

