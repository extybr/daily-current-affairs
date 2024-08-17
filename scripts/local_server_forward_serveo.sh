#!/bin/sh
terminal="terminator -g /home/tux/.config/terminator/config --new-tab -e"
${terminal} "python -m http.server 9090; zsh"
${terminal} "ssh -R 80:localhost:9090 serveo.net"
# ssh -R my-special-subdomain:80:localhost:9090 serveo.net
echo "Смотрите ссылку во вкладке терминала"

