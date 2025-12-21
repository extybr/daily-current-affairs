#!/bin/bash
# $> ./xray-proxy.sh
# TODO: backup

if curl -s 127.0.0.1:10808 &>/dev/null; then exit; fi
if ! hash xray || ! [ -d "$HOME/my_programs/xray/" ]; then
  exit
fi

if ! [ -f "$HOME/.config/autostart/xray-proxy.desktop" ]; then
  echo "[Desktop Entry]
Type=Application
Name=xray-proxy
Comment=xray-proxy script
Path=${SCRIPTS_DIRECTORY}/vpn
Exec=xray-proxy
StartupNotify=false
Terminal=false" > xray-proxy.desktop
  mv xray-proxy.desktop "$HOME/.config/autostart"
fi

if ! [ -f "${SCRIPTS_DIRECTORY}/vpn/xray-proxy" ]; then
  cd "${SCRIPTS_DIRECTORY}/vpn"
  shc -r -f xray-proxy.sh
  rm xray-proxy.sh.x.c
  mv xray-proxy.sh.x xray-proxy
  chmod u=rwx,g=r,o=r xray-proxy
fi

if [ -f "${SCRIPTS_DIRECTORY}/vpn/xray-proxy" ]; then
  # sudo xray -c /usr/local/etc/xray/config.json &  # sudo
  xray -c "$HOME/my_programs/xray/config.json" &>/dev/null &
else exit 1
fi

