#! /bin/sh
sudo iptables -I INPUT -p tcp --sport 80 -m string --string "Location: http://fz139.ttk.ru" --algo bm -j DROP
