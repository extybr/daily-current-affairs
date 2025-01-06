#!/bin/sh
#########################################
# $> ./local_server_forward_serveo.sh   #
#########################################

port=9090
terminal="terminator -g $HOME/.config/terminator/config --new-tab -e"
${terminal} "python -m http.server ${port}; zsh"
${terminal} "ssh -R 80:localhost:${port} serveo.net"
# ssh -R my-special-subdomain:80:localhost:9090 serveo.net
echo "Смотрите ссылку во вкладке терминала"

