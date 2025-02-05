#!/bin/bash
# $> ./disable_vpn_service.sh
# Отключение ВПН служб

services='outline_proxy_controller.service AmneziaVPN.service'
for service in ${services}; do

  echo "${service}" | rg "${service}"

  active=$(systemctl is-active "${service}")
  if [[ "${active}" = active ]]; then
    sudo systemctl stop "${service}"
  fi

  loaded=$(systemctl is-enabled "${service}")
  if [[ "${loaded}" = enabled ]]; then
    sudo systemctl disable "${service}"
  fi

  if [ -f $HOME/.config/autostart/Outline-Client.AppImage.desktop ]; then
    rm $HOME/.config/autostart/Outline-Client.AppImage.desktop
  fi

  systemctl status "${service}" | sed -n 2,3p | rg 'disabled|enabled|inactive|active'
  
  srv=$(ls /etc/systemd/system/multi-user.target.wants/ | rg "${service}")
  if [ "$?" -ne 1 ]; then
    echo && echo "attention! ${service}" | rg "${service}" && echo
  fi

done

