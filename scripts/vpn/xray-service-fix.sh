#!/bin/bash
# $> ./xray-service-fix.sh
# Правка для запуска xray.service

my_config="$HOME/my_programs/xray/config.json"
if ! [ -f "$my_config" ]; then
  exit
fi
default_config="/usr/local/etc/xray/config.json"

sudo rm "${default_config}"
sudo cp "${my_config}" "${default_config}"
sudo sed -i "s/User=nobody/User=root/" "/etc/systemd/system/xray.service"

sudo systemctl daemon-reload
sudo systemctl start xray.service
sudo systemctl enable xray.service

