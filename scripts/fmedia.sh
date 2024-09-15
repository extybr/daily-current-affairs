#!/bin/sh
source ~/PycharmProjects/github/daily-current-affairs/scripts/set_get_volume.sh

if [ "$#" -lt 1 ]
  then echo -e "\e[31m*** Нет параметров ***\e[0m"
  exit 0
elif [ "$1" = '.' ] || [ "$#" -gt 1 ]
  then ~/my_programs/fmedia-1/./fmedia "$@"
else ~/my_programs/fmedia-1/./fmedia "$1"
fi

if ! [ $? -eq 0 ]
  then echo -e "\e[31m*** Неверные параметры ***\e[0m"
fi

