#!/bin/bash
# https://github.com/Jigsaw-Code/outline-sdk
# HACK: для запуска программы с ключами

port_8080() {
  # port=8080
  go run github.com/Jigsaw-Code/outline-sdk/x/examples/http2transport@latest \
  -transport "${outline_key}" -localAddr localhost:8080
}

port_1080() {
  # port=1080
  go run github.com/Jigsaw-Code/outline-sdk/x/examples/http2transport@latest \
  -transport "${outline_key}"
}

transport() {
  # port=1080
  ./http2transport -transport "${outline_key}"
}

if ! [ -f ~/.config/autostart/outline-sdk.desktop ]; then
  echo "[Desktop Entry]
Type=Application
Name=outline-sdk
Comment=outline-sdk script
Path=${SCRIPTS_DIRECTORY}
Exec=outline-sdk
StartupNotify=false
Terminal=false" > outline-sdk.desktop
  mv outline-sdk.desktop ~/.config/autostart
fi

if ! [ -f ${SCRIPTS_DIRECTORY}/outline-sdk ]; then
  cd ${SCRIPTS_DIRECTORY}
  shc -r -f outline-sdk.sh
  rm outline-sdk.sh.x.c
  mv outline-sdk.sh.x outline-sdk
  chmod u=rwx,g=r,o=r outline-sdk
fi

if [ -f ~/my_programs/outline-sdk/http2transport ]; then
  cd ~/my_programs/outline-sdk
  source outline.key
  transport &
elif [ -d ~/my_programs/outline-sdk ]; then
  cd ~/my_programs/outline-sdk
  source outline.key
  port_8080 &
else exit 0
fi

