#!/bin/bash
#################################################
# $> ./phiola.sh .                              #
# $> ./phiola.sh file.mp3                       #
# $> ./phiola.sh https://example.com/file.m3u   #
#################################################
# Запуск аудиопрограммы phiola с определенными параметрами

source "${SCRIPTS_DIRECTORY}"/set_get_volume.sh

if [ "$#" -lt 1 ]
  then echo -e "\e[31m*** Нет параметров ***\e[0m"
  exit 0
elif [ "$1" = '.' ] || [ "$#" -gt 1 ]
  then ~/my_programs/phiola-2/./phiola "$@"
else ~/my_programs/phiola-2/./phiola "$1"
fi

if ! [ "$?" -eq 0 ]
  then echo -e "\e[31m*** Неверные параметры ***\e[0m"
fi

