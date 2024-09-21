#!/bin/sh
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

addr_proxy

