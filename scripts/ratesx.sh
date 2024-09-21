#!/bin/sh
btc () {
WHITE='\033[1;37m'
NORMAL='\033[0m'
if [ "$#" -eq 0 ]
  then curl rate.sx
elif [ "$#" -eq 1 ]
  then curl rate.sx/"$1"
else echo -e "${WHITE} Ожидалось не более 1 параметра${NORMAL}"
fi
}
