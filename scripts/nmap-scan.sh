#!/bin/bash
# $> ./nmap-scan.sh 192.168.1.199
# Сканирование портов, указанного адреса

ports=$(nmap -p- --min-rate=500 "$1" | grep "^[0-9]" | cut -d "/" -f 1 | tr "\n" "," | sed s/,$//)
nmap -p"${ports}" -A "$1"

