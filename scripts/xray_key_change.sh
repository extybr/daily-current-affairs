#!/bin/bash
# $> ./xray_key_change.sh
# HACK: для изменения ключей в программе

cd $HOME/my_programs/xray
killall xray
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
cd ${SCRIPTS_DIRECTORY}
./xray-proxy

