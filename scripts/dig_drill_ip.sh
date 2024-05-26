#!/bin/sh
# IP address determination
# tracing blocked and not blocked IP addresses
blue="\033[36m"
normal="\033[0m"
if command -V dig &> /dev/null; then
  ip_addr=$(dig +trace "$1" @8.8.8.8 | grep -E "^$1" | grep 'A' | tr -d '\t' | cut -d 'A' -f 2)
elif command -V drill &> /dev/null; then
  ip_addr=$(drill "$1" -T @8.8.8.8 | grep -E "^$1" | grep 'A' | tr -d '\t' | cut -d 'A' -f 2)
elif command -V nslookup &> /dev/null; then
  ip_addr=$(nslookup vk.com | grep 'Address:' | grep -v '192.168.' | cut -d " " -f 2)
else echo -e "command ${blue}dig${normal}, ${blue}drill${normal} and ${blue}nslookup${normal} not found"
  exit 0
fi
echo -e "${blue}${ip_addr}${normal}"
