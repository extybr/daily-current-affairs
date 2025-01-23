#!/bin/bash
#########################################
# $> ./local_server_forward_serveo.sh   #
#########################################
# Быстрый запуск hhtp-сервера с пробросом через serveo.net

port=9090
terminal="terminator -g $HOME/.config/terminator/config --new-tab -e"
${terminal} "python -m http.server ${port}; zsh"
${terminal} "ssh -R 80:localhost:${port} serveo.net"
# HACK: ssh -R my-special-subdomain:80:localhost:9090 serveo.net
echo "Смотрите ссылку во вкладке терминала"

