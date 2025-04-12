#!/bin/zsh
# $> ./xray_key_change.sh
# HACK: для изменения ключей в программе

cd "$HOME/my_programs/xray" || exit
rm vless.key 2> /dev/null

if [ -f vless_number ]; then
  current_number=$(cat vless_number)
  if [ "${current_number}" = '4' ]; then
    current_number='0'
  fi
  number=$(( "${current_number}" + 1 ))
  echo "${number}" > vless_number
else echo '1' > vless_number
fi

unzip keys.zip "vless_${number}.key"
mv "vless_${number}.key" vless.key

text=$(cat "$HOME/my_programs/xray/vless.key")

id=$(echo "${${text}:17:36}")
sed -i "s/\"id\": \".\{36\}\"/\"id\": \"$id\"/" "$HOME/my_programs/xray/config.json"

shortId=$(echo "${${text}:238:12}")
sed -i "s/\"shortId\": \".\{12\}\"/\"shortId\": \"$shortId\"/" "$HOME/my_programs/xray/config.json"

sudo systemctl stop xray.service
sudo rm "/usr/local/etc/xray/config.json"
sudo cp "$HOME/my_programs/xray/config.json" "/usr/local/etc/xray/config.json"
sudo systemctl start xray.service

