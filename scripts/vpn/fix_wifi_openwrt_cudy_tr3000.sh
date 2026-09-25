#!/bin/ash
# Fix wifi-интерфейсов после заливки прошивки OpenWrt на Cudy-TR3000-256mb
# Скрипт сразу целиком или частями запускать на роутере
# $> chmod +x fix_wifi_openwrt_cudy_tr3000.sh && ./fix_wifi_openwrt_cudy_tr3000.sh

if ls /sys/class/ieee80211/ \
  && iw phy | grep -E '^Wiphy' | tr '\n' ' ' | awk '{print $2,$4}' \
  && uci show wireless | grep "wifi-device"; then
  echo -e "\e[36mwifi-интерфейсы обнаружены\e[0m"
else echo -e "\e[31mwifi-интерфейсы не обнаружены\e[0m" && exit
fi

wifi config | grep 'Syntax error' || echo -e "\e[36mПроблем не обнаружено\e[0m" && exit

rm /etc/board.json

cat > /etc/board.json << 'EOF'
{
  "model": {
    "id": "cudy,tr3000-256mb-v1",
    "name": "Cudy TR3000 256MB v1"
  },
  "wlan": {
    "phy0": {
      "path": "platform/soc/18000000.wifi",
      "band": "2g"
    },
    "phy1": {
      "path": "platform/soc/18000000.wifi+1",
      "band": "5g"
    }
  }
}
EOF

cp /etc/board.json /etc/board.json.backup

wifi config
wifi config | grep 'Syntax error' && echo -e "\e[31mПроблема не устранена\e[0m" && exit

if cat /etc/config/wireless | grep config &>/dev/null; then echo -e "\e[36mПроблема исправлена\e[0m"; fi

