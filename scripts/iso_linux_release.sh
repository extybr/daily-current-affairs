#!/bin/bash
# iso linux release

curl -s 'https://mirror.yandex.ru' | grep 'dir' -A 9 | grep -oP '(📁|date")[^<]+' | sed 'n;G ; s/date">//g'
echo
echo -n Kali
curl -s --location 'https://www.kali.org/releases' | grep -m 1 -A 7 'content="Kali Linux Release History' | tail -5
echo Arch
arch=$(curl -s --location 'https://archlinux.org/download')
echo "$arch" | grep -A 2 'Current Release' | sed 's/ <li><strong>// ; s/<\/strong>// ; s/<\/li>//' | awk '{print $1,$2,$3}'
magnet=$(echo "$arch" | grep '<li><a href="magnet' | sed 's/<li><a href="// ; s/"//' | awk '{print $1}')
echo -e "Magnet-url: $magnet\n"
echo CachyOS
curl -s --location 'https://cachyos.org/download' | grep -oP 'https:[^\]]+iso'

