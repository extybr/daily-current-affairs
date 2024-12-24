#!/bin/bash
# $> ./kinobox_players.sh 1207839

violet="\e[35m"
blue="\e[36m"
yellow="\e[33m"
normal="\e[0m"

if [ "$#" -ne 1 ]; then
  echo -e "${yellow}Ожидалось 1 параметр${normal}"
  exit 0
fi

source ./proxy.sh 1> /dev/null

search="kinopoisk"  # kinopoisk, imdb, query
id="$1"  # 1207839, tt0120804, 1207839
url="https://kinobox.tv/api/players?${search}=${id}"

request=$(curl -s ${proxy} "${url}")

for item in {0..100}; do
  source=$(echo "${request}" | jq -r ".[$item].source")
  iframeUrl=$(echo "${request}" | jq -r ".[$item].iframeUrl")
  if [ "${source}" == "null" ]; then
    break
  else echo -e "${blue}${source}\n${violet}${iframeUrl}\n"
  fi
done
echo -ne "${normal}"
