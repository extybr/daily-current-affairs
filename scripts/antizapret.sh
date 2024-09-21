#!/bin/sh
#antizapret.prostovpn.org
#if printf "\e[35m%s\e[0m" "$(curl -i -s https://p.thenewone.lol:8443/proxy.pac | rg "location:" | cut -f2 -d " ")"; then echo ; fi
address=$(curl --max-time 3 -i -s https://p.thenewone.lol:8443/proxy.pac | \
grep "location:" | cut -f2 -d " ")
if [ "${#address}" -gt 0 ]; then echo -e "\e[35m${address}\e[0m"; fi

#also works:
#sudo -- sh -c "echo '195.123.208.131 antizapret.prostovpn.org' >> /etc/hosts"
#and
#curl -i -s https://antizapret.prostovpn.org:8443/proxy.pac | rg "location:" | cut -f2 -d " "
