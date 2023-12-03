#!/bin/sh
curl wttr.in/Komsomolsk-on-Amur?lang=ru
echo
echo "********************************"
msg="Your IP address: "
date=$(date "+%d-%m-%y %T")
ip=$(curl -s "https://api.ipify.org")
echo $msg "\e[31m$ip\e[0m" "(time: $date)"
echo "********************************"

