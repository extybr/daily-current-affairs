#!/bin/sh
ip -c route
ident=$(curl -s --max-time 2 "http://ident.me")
if [ "${#ident}" -gt 0 ]; then printf "Your IP address: \e[31m%s\e[0m \e[37m > http://ident.me\e[0m\n" "${ident}"; fi
myip=$(curl -s --max-time 2 "https://api.myip.com" | jq -r ".ip")
if [ "${#myip}" -gt 0 ]; then printf "Your IP address: \e[31m%s\e[0m \e[37m > https://api.myip.com\e[0m\n" "${myip}"; fi
ifconfig=$(curl -s --max-time 2 ifconfig.me)
if [ "${#ifconfig}" -gt 0 ]; then printf "Your IP address: \e[31m%s\e[0m \e[37m > ifconfig.me\e[0m\n" "${ifconfig}"; exit 0; fi
