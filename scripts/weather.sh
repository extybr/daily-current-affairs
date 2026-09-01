#!/bin/bash
##############################
# $> ./weather.sh            #
# $> ./weather.sh New-York   #
##############################
# Выводит прогноз погоды в консоль с сайта wttr.in, указанного города

region="Komsomolsk-on-Amur"
if [ "$#" -eq 1 ]
  then region="$1"
elif [ "$#" -gt 1 ]
  then echo -e "\033[37m*** ожидалось не более 1 параметра, а передано $# ***\033[0m"
  exit 1
fi

#curl --connect-timeout 3 wttr.in/Komsomolsk-on-Amur?lang=ru
curl --max-time 5 wttr.in/"${region}"?lang=ru
printf "\n********************************\n(time: \e[31m%s\e[0m)\n********************************\n" \
       "$(date "+%d-%m-%y %T")"

# timeout 3s inxi -x -w 2>/dev/null
