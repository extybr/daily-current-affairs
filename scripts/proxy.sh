#!/bin/bash
# Показывает используемый прокси адрес

addr_proxy() {
address=$(curl -s --location --max-time 3 'https://p.thenewone.lol:8443/proxy.pac' | \
grep 'return "PROXY' | sed 's/; DIRECT";//g ; s/    return "PROXY //g')
proxy="--proxy ${address}"
if ! [ "${address}" ] || [ "$?" = '124' ]; then
  sleep 2
  echo 'not found or timeout'
  addr_proxy
fi
}

proxy=''
if curl -s localhost:1080 &> /dev/null; then
  proxy="--proxy localhost:1080"  # outline-sdk
elif curl -s localhost:10808 &> /dev/null; then
  proxy="--proxy localhost:10808"  # xray-proxy
elif curl -s localhost:8080 &> /dev/null; then
  proxy="--proxy localhost:8080"
else addr_proxy
# FIXME: else proxy="--proxy n.thenewone.lol:29976"
fi
echo "${proxy} "

