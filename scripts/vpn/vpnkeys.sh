#!/bin/bash
# $> ./vpnkeys.sh 
# Бесплатные временные ключи VPN с github + ресурсы для их поиска

# tiagorrg / all keys / grep
keys_v1() {
  curl -s 'https://raw.githubusercontent.com/tiagorrg/vless-checker/refs/heads/main/docs/keys.json' \
    | grep -oP '"key":\K[^<]+"' | sort | uniq | sed 's/.$/\n/g ; s/^..//g'
}

# tiagorrg / all keys / jq
keys_v2() {
  curl -s 'https://raw.githubusercontent.com/tiagorrg/vless-checker/refs/heads/main/docs/keys.json' \
    | jq -r '.. | .key? // empty' | sort | uniq | nl
}

# tiagorrg / best name+key / jq
name_key() {
  request=$(curl -s 'https://raw.githubusercontent.com/tiagorrg/vless-checker/refs/heads/main/docs/keys.json' \
            | jq | grep -oP '"best":\K[^<]+"' | sed 's/"//g ; s/ /\n/g')
  for url in $request; do
    name="${url##*#}"; name=$(printf '%b' "${name//%/\\x}"); echo -e "$name\n$url\n"
  done
}

# source
src_urls() {
  echo -e "\nhttps://tiagorrg.github.io/vless-checker/
https://github.com/tiagorrg/vless-checker
https://github.com/igareck/vpn-configs-for-russia
https://github.com/kort0881
https://github.com/kort0881/vpn-vless-configs-russia
https://kort0881.github.io/internet-access-site/#configs"
}


case "$1" in
  1) keys_v1
  ;;
  2) keys_v2
  ;;
  3) name_key
  ;;
  *) echo "Example:
./vpnkeys.sh 1 - tiagorrg / all keys / grep
./vpnkeys.sh 2 - tiagorrg / all keys / jq
./vpnkeys.sh 3 - tiagorrg / best name+key / jq"
  ;;
esac

src_urls

