#!/bin/bash
############################################
# ./current_time_area_google.sh New-York   #
############################################
# Показывает текущее время указанного города/региона с сайта google.com или time.is

REGION=$(echo "$1" | sed 's/ /-/g')
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64; rv:146.0) Gecko/20100101 Firefox/146.0"
NUMBER=10

GMT=$(curl -s -I 'https://google.com' | grep 'date:')

google() {
# FIXME: закомментированный код перестал работать
#  time=$(curl -s --max-time 5 -A "${USER_AGENT}" "https://www.google.com/search?q=current+time+${REGION}" | \
#         grep -oP '"3" role="heading">[^<]+' | sed "s/\"3\" role=\"heading\">/\\n/g")
  ct=$(echo "${GMT}" | awk '{print $6}')
  if [[ "${ct}" ]]; then
    ctt="${ct:0:2}"
    if [ "${ctt:0:-1}" = '0' ]; then ctt="${ctt/0/}"; fi
    if (( $ctt > 13 )) && (( $ctt < 24 )); then
      ctt=$(( $ctt - 14 ))
    else ctt=$(( "${ctt}" + "${NUMBER}" ))
    fi
    TIME="${ctt}${ct:2}"
  fi
}

time_is() {
  TIME=$(curl -s --max-time 5 -A "${USER_AGENT}" --location "https://time.is/${REGION}" | \
         grep -oP '<time id="clock">[^<]+</t' | sed 's/<time id="clock">//g ; s/<\/t//g')
}

if [ "$#" -eq 1 ] && time_is && [[ "${TIME}" ]]; then
  true
else google
fi

echo -e "\n\e[31m ${TIME}\e[0m\n"
echo "${GMT}"  # date (GMT) from google

