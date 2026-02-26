#!/bin/bash
# Network packet processor with a friendly UI for circumventing Deep Packet Inspection (DPI) systems
# https://github.com/DanielLavrushin/b4
# https://daniellavrushin.github.io/b4/

# https://habr.com/ru/articles/982498/
# http://localhost:7000
# -restart=always

docker run --network host --cap-add NET_ADMIN --cap-add NET_RAW --cap-add SYS_MODULE -v /etc/b4:/etc/b4 lavrushin/b4:latest --web-port 7000

