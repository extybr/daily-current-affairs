#!/bin/sh
#############################################
# $> ./timestamp.sh                         #
# $> ./timestamp.sh 1727095798              #
# $> ./timestamp.sh '05/30/2024 21:39:46'   #
#############################################

white="\e[37m"
blue="\e[36m"
yellow="\e[33m"
normal="\e[0m"
red="\e[31m"

errors() {
echo -e "${red}The data format is invalid.${normal}\n${yellow}Example:"
echo -e "convert timestamp to date:${normal} '${blue}1725787421${normal}'"
echo -e "${yellow}convert date to timestamp:${normal} '${blue}m/d/y H:M:S${normal}'"
}

if [ "$#" -eq 0 ]
  then current_ts=$(date +%s)  # unix timestamp
  echo -e "${blue}${current_ts}${normal}"
elif [ "$#" -eq 1 ]
  then 
  if [ "$1" -gt 0 ] 2>/dev/null
    then ts=$(date --date="@$1" 2> /dev/null)
    if ! [[ "${ts}" ]]
      then errors
      else echo -e "${blue}${ts}${normal}"
    fi
  else dt=$(date -d "$1" +"%s" 2> /dev/null)
    if ! [[ "${dt}" ]]
      then errors
      else echo -e "${blue}${dt}${normal}"
    fi
  fi
else echo -e "${white}1 parameter was expected, but passed $#${normal}"
fi

