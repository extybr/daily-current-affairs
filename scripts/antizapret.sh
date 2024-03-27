#!/bin/sh
if printf "\e[35m%s\e[0m" "$(curl -i -s https://antizapret.prostovpn.org:8443/proxy.pac | rg "location:" | cut -f2 -d " ")"; then echo ; fi
