#!/bin/bash
# Проверка доступности внешней сети (интернета) NetworkManager / Firefox

# команда отключает проверку только до перезагрузки или перезапуска NetworkManager
sudo nmcli networking connectivity check disable

# меняем адрес проверки доступности глобальной сети для NetworkManager
echo "[connectivity]
uri=http://nmcheck.gnome.org/check_network_status.txt" > /etc/NetworkManager/conf.d/20-connectivity.conf
# uri=ping.archlinux.org
# uri=example.org

# отключает проверку
# echo "[connectivity]
# enabled=false" > /etc/NetworkManager/conf.d/20-connectivity.conf

# Проверка доступности внешней сети (интернета) Firefox через curl
curl -s detectportal.firefox.com || exit 1
