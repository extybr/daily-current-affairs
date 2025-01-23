#!/bin/sh
##############################
# $> ./weather.sh            #
# $> ./weather.sh New-York   #
##############################
# Выводит прогноз погоды в консоль с сайта wttr.in, указанного города

WHITE="\033[37m"
NORMAL="\033[0m"

region="Komsomolsk-on-Amur"
if [ "$#" -eq 1 ]
  then region="$1"
elif [ "$#" -gt 1 ]
  then echo -e "${WHITE}ожидалось не более 1 параметра, а передано $#${NORMAL}"
  exit 1
fi

#curl --connect-timeout 3 wttr.in/Komsomolsk-on-Amur?lang=ru
curl --max-time 3 wttr.in/"${region}"?lang=ru
printf "\n********************************\n(time: \e[31m%s\e[0m)\n********************************\n" \
       "$(date "+%d-%m-%y %T")"
timeout 3s inxi -x -w 2> /dev/null

