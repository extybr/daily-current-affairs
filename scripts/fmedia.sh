#!/bin/sh
#################################################
# $> ./fmedia.sh .                              #
# $> ./fmedia.sh file.mp3                       #
# $> ./fmedia.sh https://example.com/file.m3u   #
#################################################

source ./set_get_volume.sh

if [ "$#" -lt 1 ]
  then echo -e "\e[31m*** Нет параметров ***\e[0m"
  exit 0
elif [ "$1" = '.' ] || [ "$#" -gt 1 ]
  then ~/my_programs/fmedia-1/./fmedia "$@"
else ~/my_programs/fmedia-1/./fmedia "$1"
fi

if ! [ "$?" -eq 0 ]
  then echo -e "\e[31m*** Неверные параметры ***\e[0m"
fi

