#!/bin/sh
############################################
# ./current_time_area_google.sh New-York   #
############################################

region=$(echo "$1" | sed 's/ /-/g')
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64; rv:133.0) Gecko/20100101 Firefox/133.0"

google() {
  time=$(curl -s --max-time 5 -A "${USER_AGENT}" "https://www.google.com/search?q=current+time+$1" | \
         grep -oP '"3" role="heading">[^<]+' | sed "s/\"3\" role=\"heading\">/\\n/g")
  echo "${time}"
}

time_is() {
  time=$(curl -s --max-time 5 -A "${USER_AGENT}" --location "https://time.is/$1" | \
         grep -oP '<time id="clock">[^<]+</t' | sed 's/<time id="clock">//g ; s/<\/t//g')
  echo "${time}"
}

exact_time=$(google "${region}")
if ! [[ "${exact_time}" ]]; then
  exact_time=$(time_is "${region}")
fi

echo -e "\n\e[31m${exact_time}\e[0m\n"
curl -I 'https://google.com' 2>&1 | grep date  # date (GMT) from google

