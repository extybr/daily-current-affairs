#!/bin/bash
# $> ./xray_config_fix.sh "vless://bla-bla-bla"
# Правка конфигурационного файла xray

config="$HOME/my_programs/xray/config.json"
if ! [ -f "$config" ]; then
  exit
fi

if [ "$#" -eq 1 ]; then
  key="$1"
else key="vless://00000000-0000-0000-0000-000000000000@2ip.ru:443?security=reality&encryption=none&headerType=none&fp=chrome&type=tcp&flow=xtls-rprx-vision&pbk=xxxxx_xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxx&sni=mail.ru&sid=00ff00ff00ff#195%20%D0%9D%D0%B5%D0%B7%D1%8B%D0%B1%D0%BB%D0%B5%D0%BC%D1%8B%D0%B9%20%D0%9B%D0%B0%D0%BC%D0%B0%D1%81"
fi

id=$(echo "${key}" | grep -oP 'vless://[^>]+@' | sed 's/^.\{8\}//g ; s/@//g')
server_addr=$(echo "${key}" | grep -oP "${id}[^>]+?sec" | sed "s/${id}@//g ; s/........$//g")
server_ip_addr=$(ping -c 1 "${server_addr}" | head -n 1 | awk '{print $3}' | sed 's/^.//g ; s/.$//g')
public_key=$(echo "${key}" | grep -oP '&pbk=[^>]+&sni' | sed 's/&pbk=//g ; s/&sni//g')
server_name=$(echo "${key}" | grep -oP '&sni=[^>]+&' | sed 's/sni=//g ; s/&//g')
short_id=$(echo "${key}" | grep -oP '&sid=[^>]+#' | sed 's/&sid=//g ; s/#//g')

old_server_ip_addr=$(cat "${config}" | jq -r '.outbounds.[].settings.vnext.[].address')
old_public_key=$(cat "${config}" | jq -r '.outbounds.[].streamSettings.realitySettings.publicKey')
old_server_name=$(cat "${config}" | jq -r '.outbounds.[].streamSettings.realitySettings.serverName')
old_short_id=$(cat "${config}" | jq -r '.outbounds.[].streamSettings.realitySettings.shortId')
old_id=$(cat "${config}" | jq -r '.outbounds.[].settings.vnext.[].users.[].id')

sed -i "s/${old_server_ip_addr}/${server_ip_addr}/" "${config}"
sed -i "s/${old_public_key}/${public_key}/" "${config}"
sed -i "s/${old_server_name}/${server_name}/" "${config}"
sed -i "s/${old_short_id}/${short_id}/" "${config}"
sed -i "s/${old_id}/${id}/" "${config}"

echo "id= ${id}"
echo "server_ip_addr= $server_ip_addr"
echo "public_key= $public_key"
echo "server_name= $server_name"
echo "short_id= $short_id"

