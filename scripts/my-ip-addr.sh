#!/bin/bash
# $> ./my-ip-addr.sh
# Показывает ip-адреса устройства, с которого запущен скрипт

ip -c route

function ip_addr {
  response=$(curl -s --max-time 3 "$1")
  if [ "$#" -eq 2 ]; then
    response=$(echo "${response}" | jq -r "$2")
  fi
}

if ip_addr "ifconfig.me" && [ "${response}" ]; then
  src="ifconfig.me"
elif ip_addr "https://api.myip.com" ".ip" && [ "${response}" ]; then
  src="api.myip.com"
elif ip_addr "http://ident.me" && [ "${response}" ]; then
  src="ident.me"
elif ip_addr "https://ipwho.is/?output=json" ".ip" && [ "${response}" ]; then
  src="ipwho.is"
elif ip_addr "https://wtfismyip.com/text" && [ "${response}" ]; then
  src="wtfismyip.com"
fi
printf "Your IP address: \e[31m%s\e[0m \e[37m > ${src}\e[0m\n" "${response}"

ip_proxy() {
  cd ${SCRIPTS_DIRECTORY} 2> /dev/null
  source ./proxy.sh
  curl -s ${proxy} --max-time 5 "$1"
}

for src in eth0.me ipaddress.sh curlmyip.net; do
  ip_vpn=($(ip_proxy "${src}"))
  if [[ "${#ip_vpn[@]}" -eq 3 ]]; then
    printf "Your VPN IP address: \e[31m%s\e[0m \e[37m > %s > ${src}\e[0m\n" "${ip_vpn[2]}" "${ip_vpn[1]}"
    break
  fi
done

