#!/bin/bash
# Добавляет записи в iptables для отброса пакетов (WARNING: устарело)
sudo iptables -I INPUT -p tcp --sport 80 -m string --string "Location: http://fz139.ttk.ru" --algo bm -j DROP
sudo iptables -I INPUT -p tcp --sport 80 -m string --string "Location: http://blocked.mts.ru" --algo bm -j DROP
