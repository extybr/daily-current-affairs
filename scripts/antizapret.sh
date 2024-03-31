#!/bin/sh
#antizapret.prostovpn.org
if printf "\e[35m%s\e[0m" "$(curl -i -s https://p.thenewone.lol:8443/proxy.pac | rg "location:" | cut -f2 -d " ")"; then echo ; fi

#also works:
#sudo -- sh -c "echo '195.123.208.131 antizapret.prostovpn.org' >> /etc/hosts"
#and
#curl -i -s https://antizapret.prostovpn.org:8443/proxy.pac | rg "location:" | cut -f2 -d " "
