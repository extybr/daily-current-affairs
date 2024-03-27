#!/bin/sh
ip -c route
if printf "Your IP address: \e[31m%s\e[0m" "$(curl -s "https://api.ipify.org")"; then printf "\e[37m > https://api.ipify.org\e[0m\n"; fi
if printf "Your IP address: \e[31m%s\e[0m" "$(curl -s "http://ident.me")"; then printf "\e[37m > http://ident.me\e[0m\n"; fi
if printf "Your IP address: \e[31m%s\e[0m" "$(curl -s --connect-timeout 2 "https://api.myip.com" | jq -r ".ip")"; then printf "\e[37m > https://api.myip.com\e[0m\n"; fi
if printf "Your IP address: \e[31m%s\e[0m" "$(curl -s ifconfig.me)"; then printf "\e[37m > ifconfig.me\e[0m\n"; fi
