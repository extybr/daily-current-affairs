#!/bin/bash
# $> ./antidpi_check_upd.sh
# Вывод последних релизов VPN-клиентов, antidpi и т.д. (кликабельные ссылки, 2 варианта)

repos=(bol-van/zapret bol-van/zapret2 Flowseal/tg-ws-proxy SagerNet/sing-box hiddify/hiddify-app amnezia-vpn/amnezia-client GVCoder09/NoDPI Waujito/youtubeUnblock remittor/zapret-openwrt StressOzz/Zapret-Manager)

request_v1() {
  declare -A targets=(
    [bol-van/zapret]="\e]8;;https://github.com/bol-van/zapret\e\\ zapret\e]8;;\e\\\\"
    [bol-van/zapret2]="\e]8;;https://github.com/bol-van/zapret2\e\\ zapret2\e]8;;\e\\\\"
    [Flowseal/tg-ws-proxy]="\e]8;;https://github.com/Flowseal/tg-ws-proxy\e\\ tg-ws-proxy\e]8;;\e\\\\"
    [SagerNet/sing-box]="\e]8;;https://github.com/SagerNet/sing-box\e\\ sing-box\e]8;;\e\\\\"
    [hiddify/hiddify-app]="\e]8;;https://github.com/hiddify/hiddify-app\e\\ hiddify-app\e]8;;\e\\\\"
    [amnezia-vpn/amnezia-client]="\e]8;;https://github.com/amnezia-vpn/amnezia-client\e\\ amnezia-client\e]8;;\e\\\\"
    [GVCoder09/NoDPI]="\e]8;;https://github.com/GVCoder09/nodpi\e\\ nodpi\e]8;;\e\\\\"
    [Waujito/youtubeUnblock]="\e]8;;https://github.com/Waujito/youtubeUnblock\e\\ youtubeUnblock\e]8;;\e\\\\"
    [remittor/zapret-openwrt]="\e]8;;https://github.com/remittor/zapret-openwrt\e\\ zapret-openwrt\e]8;;\e\\\\"
    [StressOzz/Zapret-Manager]="\e]8;;https://github.com/StressOzz/Zapret-Manager\e\\ Zapret-Manager\e]8;;\e\\\\"
  )

  for repo in "${repos[@]}"; do
    data=($(curl -s "https://api.github.com/repos/${repo}/releases" | jq -r '.[0] | .tag_name, .published_at'))
    # echo -e "\033[37m$repo\033[0m | тэг: \033[36m${data[0]}\033[0m | дата: \033[36m${data[1]}\033[0m"
    tag="${data[0]}"
    pubdate=$(echo "${data[1]}" | sed 's/[TZ]/ /g')
    echo -e "\e[35m${targets[$repo]}\e[0m | тэг: \033[36m${tag}\033[0m | дата: \033[36m${pubdate}\033[0m"
  done
}

request_v2() {
  for repo in "${repos[@]}"; do
    data=($(curl -s "https://api.github.com/repos/${repo}/releases" | jq -r '.[0] | .tag_name, .published_at'))
    printf "\e]8;;https://github.com/$repo\e\\\\\e[35m%-14s\e[0m\e]8;;\e\\ | тэг: \e[36m%-18s\e[0m | дата: \e[36m%s\e[0m\n" \
      "$(basename $repo)" "${data[0]}" "$(echo "${data[1]}" | sed 's/[TZ]/ /g')"
  done
}

# request_v1
request_v2
