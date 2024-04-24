#!/bin/sh

# Script to turn off an access point (access point mode) or 
# disconnect an active connection (client mode)

# Example:
# ap (ssid) = "<Hello World !!!>"
# and
#    nmcli con down $ssid
#    nmcli dev | grep $ssid | tr -s ' ' | cut -d ' ' -f4-99 | xargs nmcli con down
# commands not work

# jq  (Command-line JSON processor)
# jc  (converts the output of many commands, file-types, and strings to JSON or YAML)

nm_con=$(jc -p nmcli con show)
for index in {0..30}
do
  device=$(echo "${nm_con}" | jq -r ".["${index}"].device")
  if [ "${device}" = "$1" ]; then 
    nmcli con down $(echo "${nm_con}" | jq -r ".["${index}"].uuid")
    break
  fi
done
