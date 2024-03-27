#!/bin/bash
#docker run -d --restart=always -v /home/sv/torrserver/db:/torrserver/db  -p 8090:8090  sv43rus/torrserver:v1
#docker run -d -v /home/sv/torrserver/db:/torrserver/db  -p 8090:8090  sv43rus/torrserver:v1
docker run -d -v /home/tux/torrserver/db:/torrserver/db -p 8090:8090 --name my_torrserve --rm sv43rus/torrserver:v1
