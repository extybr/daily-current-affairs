#!/bin/bash
# $> ./outline_key_change.sh
# HACK: для изменения ключей в программе

cd ~/my_programs/outline-sdk
pkill http2transport
rm outline.key 2> /dev/null
if [ -f outline_number ]; then
  current_number=$(cat outline_number)
  if [ "${current_number}" = '4' ]; then
    current_number='0'
  fi
  number=$(( "${current_number}" + 1 ))
  echo "${number}" > outline_number
else echo '1' > outline_number
fi
unzip keys.zip "outline_${number}.key"
mv "outline_${number}.key" outline.key
cd ${SCRIPTS_DIRECTORY}
./outline-sdk
 
