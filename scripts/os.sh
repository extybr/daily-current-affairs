#!/bin/sh
cat /etc/os-release
hostnamectl
neofetch
printf "Your IP address: \e[31m%s\e[0m  (time: %s)\n" "$(curl -s https://api.ipify.org)" "$(date "+%d-%m-%y_%T")"
uname -a
