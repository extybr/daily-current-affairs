#!/bin/bash
####################################
# $> ./wlan_disconnect.sh $wlan0   #
####################################

# Script to turn off an access point (access point mode) or 
# disconnect an active connection (client mode)
# Отключение активного подключения, переданного в качестве параметра

if [ "$#" -ne 1 ]; then
  echo "--- 1 parameter was expected ---" && exit 0
fi

nm_con=$(nmcli -t -f uuid,device con show)

while IFS=: read -r uuid device; do
  if [ "${device}" = "$1" ]; then 
    nmcli con down "${uuid}"
    break
  fi
done <<< "$nm_con"

