#!/bin/bash
##################################
# $> ./size_folder_and_file.sh   #
##################################
# Запрашивает путь к папке и показывает является ли объект в текущей директории файлом или папкой

BOLD=$(tput bold)
BEL=$(tput bel)
CLEAR=$(tput clear)
NORMAL=$(tput sgr0)
BLINK="\t\033[5m"
YELLOW="\t\e[33m"
NORM="\033[0m"
PINK="\E[37;44m"
BLUE="\E[37;45m"
DEFAULT="\E[0m"
WHITE="\033[37;1;41m"

read -rp "${CLEAR}${BEL}${BOLD}Path: ${NORMAL}" directory
for folder in "${directory}"/*
do
  if [ -d "${folder}" ]
    then printf "${PINK}%s${DEFAULT}" "$(du -hs "${folder}")"; echo -e "${YELLOW}is folder${NORM}"
  elif [ -f "${folder}" ]
    then printf "${BLUE}%s${DEFAULT}" "$(du -hs "${folder}")"; echo -e "${BLINK}is file${NORM}"
  else
    echo -en "${WHITE} UNKNOW ${NORM}"
  fi
done

