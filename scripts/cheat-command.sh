#!/bin/bash
#################################
# $> ./cheat-command.sh curl    #
#################################
# Вывод справки о программе с сайта cheat.sh

yellow="\033[33m"
normal="\033[0m"

if [ "$#" -ne 1 ]; then 
  echo -e "${yellow}Ожидалось 1 параметр, а передано $#${normal}"
  exit 0
fi

curl --max-time 10 cheat.sh/"$1"

