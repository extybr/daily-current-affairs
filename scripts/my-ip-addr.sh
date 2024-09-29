#!/bin/sh
#######################
# $> ./my-ip-addr.sh  #
#######################

ip -c route

ident=$(curl -s --max-time 3 "http://ident.me")
if [ "${#ident}" -gt 0 ]
  then printf "Your IP address: \e[31m%s\e[0m \e[37m > http://ident.me\e[0m\n" "${ident}"
fi

myip=$(curl -s --max-time 3 "https://api.myip.com" | jq -r ".ip")
if [ "${#myip}" -gt 0 ]
  then printf "Your IP address: \e[31m%s\e[0m \e[37m > https://api.myip.com\e[0m\n" "${myip}"
fi

ifconfig=$(curl -s --max-time 3 ifconfig.me)
if [ "${#ifconfig}" -gt 0 ]
  then printf "Your IP address: \e[31m%s\e[0m \e[37m > ifconfig.me\e[0m\n" "${ifconfig}"
fi

ip_proxy() {
source ~/PycharmProjects/github/daily-current-affairs/scripts/proxy.sh
curl -s ${proxy} --max-time 5 "https://wtfismyip.com/text"
}

ip_vpn=($(ip_proxy))
if [[ "${ip_vpn}" ]]
  then printf "Your VPN IP address: \e[31m%s\e[0m \e[37m > %s\e[0m\n" "${ip_vpn[2]}" "${ip_vpn[1]}"
fi

