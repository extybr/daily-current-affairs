#!/bin/sh
cat /etc/os-release; echo
hostnamectl; echo
inxi -c11 -F 2> /dev/null
printf "\n%s\n\n" "$(pacman-mirrors)"
neofetch 2> /dev/null
printf "Your IP address: \e[31m%s\e[0m  (time: %s)\n" "$(curl -s --max-time 3 ifconfig.me)" "$(date "+%d-%m-%y %T")"
uname -a
