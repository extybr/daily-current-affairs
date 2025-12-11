#!/bin/bash
# $> ./open_ports.sh
# Открытые порты, слушащие порты, счетчик использования портов

open_ports() {
  echo "*****  открытые порты на хосте  *****"
  netstat -lpan 2>/dev/null | \
  awk '/^(tcp|udp)/ {print $4}' | \
  awk -F: '{print $NF}' | \
  sort -nu | \
  nl
}
  
listen_ports() {
  echo "*****  слушащие порты  *****"
  netstat -lpan 2>/dev/null | \
  awk '$6 == "LISTEN" && /^(tcp|udp)/ {print $4}' | \
  awk -F: '{print $NF}' | \
  sort -nu | \
  nl
}

counter_ports() {
  echo "*****  счетчик использования портов  *****"
  netstat -lpan 2>/dev/null | \
  awk '/^(tcp|udp)/ {split($4, a, ":"); port = a[length(a)]; count[port]++} 
       END {for (p in count) printf "%5d %s\n", p, count[p]}' | \
  sort -n
}

counter_ports
listen_ports
open_ports
