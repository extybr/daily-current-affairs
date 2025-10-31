@echo off
color 0B
mode con:cols=100 lines=20
curl --max-time 5 -i -s https://p.thenewone.lol:8443/proxy.pac
cmd