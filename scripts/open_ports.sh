#!/bin/sh
########################
# $> ./open_ports.sh   #
########################

echo "*****  open ports on my host  *****"

# FIXME: возможные варианты >
# lsof -i -n -P | tr -s " " | cut -d " " -f 9 | cut -d ":" -f 2 | \
# cut -d "-" -f 1 | grep -v "NAME"

netstat -tulpan 2> /dev/null | tr -s " " | \
  cut -d " " -f 4 | cut -d ":" -f 2-999 | \
  tail -n +3 | sed "s/:1://g ; s/://g" | \
  sort -n | uniq | nl

