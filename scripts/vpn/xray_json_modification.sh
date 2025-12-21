#!/bin/bash
# $> ./xray_json_modification.sh
# Изменение конфига xray

config="$HOME/my_programs/xray/config.json"
if ! [ -f "$config" ]; then
  exit
fi

cp "${config}" "${config}.backup"

new_protocol=''
new_local_port=''
new_server_ip_addr=''
new_server_port=''
new_fingerprint=''
new_public_key=''
new_server_name=''
new_short_id=''
new_security=''
new_flow=''
new_id=''
new_encryption=''

list=("$new_protocol" "$new_local_port" "$new_server_ip_addr" \
      "$new_server_port" "$new_fingerprint" "$new_public_key" \
      "$new_server_name" "$new_short_id" "$new_security" \
      "$new_flow $new_id" "$new_encryption")

for item in "${list[@]}"; do
  if ! [[ "${item}" ]]; then
    echo Не все поля заполнены && exit 1
  fi
done

protocol=$(cat conf.json | jq -r '.outbounds.[].protocol')
local_port=$(cat "${config}" | jq -r '.inbounds.[].port')
server_ip_addr=$(cat "${config}" | jq -r '.outbounds.[].settings.vnext.[].address')
server_port=$(cat "${config}" | jq -r '.outbounds.[].settings.vnext.[].port')
fingerprint=$(cat "${config}" | jq -r '.outbounds.[].streamSettings.realitySettings.fingerprint')
public_key=$(cat "${config}" | jq -r '.outbounds.[].streamSettings.realitySettings.publicKey')
server_name=$(cat "${config}" | jq -r '.outbounds.[].streamSettings.realitySettings.serverName')
short_id=$(cat "${config}" | jq -r '.outbounds.[].streamSettings.realitySettings.shortId')
security=$(cat conf.json | jq -r '.outbounds.[].streamSettings.security')
flow=$(cat conf.json | jq -r '.outbounds.[].settings.vnext.[].users.[].flow')
id=$(cat conf.json | jq -r '.outbounds.[].settings.vnext.[].users.[].id')
encryption=$(cat conf.json | jq -r '.outbounds.[].settings.vnext.[].users.[].encryption')

sed -i "s/$protocol/$new_protocol/" "${config}"
sed -i "s/$local_port/$new_local_port/" "${config}"
sed -i "s/$server_ip_addr/$new_server_ip_addr/" "${config}"
sed -i "s/$server_port/$new_server_port/" "${config}"
sed -i "s/$fingerprint/$new_fingerprint/" "${config}"
sed -i "s/$public_key/$new_public_key/" "${config}"
sed -i "s/$server_name/$new_server_name/" "${config}"
sed -i "s/$short_id/$new_short_id/" "${config}"
sed -i "s/$security/$new_security/" "${config}"
sed -i "s/$flow/$new_flow/" "${config}"
sed -i "s/$id/$new_id/" "${config}"
sed -i "s/$encryption/$new_encryption/" "${config}"

