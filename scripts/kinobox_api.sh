#!/bin/bash
# $> ./kinobox_api.sh 'Resident Evil'

violet="\e[35m"
blue="\e[36m"
yellow="\e[33m"
white="\e[37m"
bold="\e[1m"
normal="\e[0m"

if [ "$#" -ne 1 ]
	then echo -e "${yellow}ожидалось 1 параметр, а передано $#${normal}"
	exit 1
fi

film=$(./url_encoder.py "$1" | sed 's/ /%20/g')
url="https://kinobox.tv/api/films/search/?title=${film}"
request=$(curl -s "${url}")
if [[ "${request}" ]]; then
  for item in {0..100}; do
    title=$(echo "${request}" | jq -r ".[$item].title")
    alternativeTitle=$(echo "${request}" | jq -r ".[$item].alternativeTitle")
    id=$(echo "${request}" | jq -r ".[$item].id")
    year=$(echo "${request}" | jq -r ".[$item].year")
    if [[ "${title}" = 'null' ]]; then
      break
    else echo -e "${blue}${title}${normal}"\
    "(${violet}${alternativeTitle}${normal} / ${yellow}${year}${normal}):"\
    "${bold}https://kinomix.web.app/#${white}${id}${normal}"
    fi
  done
fi

