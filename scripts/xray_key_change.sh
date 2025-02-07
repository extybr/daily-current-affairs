#!/bin/bash
# $> ./xray_key_change.sh
# HACK: для изменения ключей в программе

cd $HOME/my_programs/xray
killall xray
rm vpn.key 2> /dev/null

if [ -f vpn_number ]; then
  current_number=$(cat vpn_number)
  if [ "${current_number}" = '4' ]; then
    current_number='0'
  fi
  number=$(( "${current_number}" + 1 ))
  echo "${number}" > vpn_number
else echo '1' > vpn_number
fi

unzip keys.zip "vpn_${number}.key"
mv "vpn_${number}.key" vpn.key
cd ${SCRIPTS_DIRECTORY}
./xray-proxy

