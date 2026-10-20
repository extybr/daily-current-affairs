#!/bin/sh
# $> ./network_check.sh
# Проверка подключения к интернету

# Проверка подключения к интернету в оболочках zsh, bash, sh
if ! ping -c 1 -W 2 ping.archlinux.org >/dev/null 2>&1; then
  if [ "$(curl -s --max-time 5 detectportal.firefox.com)" != 'success' ]; then
    echo "no internet connection"
    sleep 3
    exit 1
  fi
fi

# короткий вариант, для некоторых версий sh точно не подойдет
# ping -c 1 ping.archlinux.org &>/dev/null \
#   || [[ $(curl -s --max-time 5 detectportal.firefox.com) = 'success' ]] \
#   || ( echo "no internet connection" && sleep 3 && exit 1 )

# для fish
# if not ping -c 1 -W 2 ping.archlinux.org >/dev/null 2>&1
#     if not curl -s --max-time 5 -o /dev/null -f https://detectportal.firefox.com
#         echo "no internet connection"
#         sleep 3
#         exit 1
#     end
# end

######################## more

# Проверка смещения времени (не меняет часы, только показывает)
# time.google.com, time.windows.com, time.apple.com, pool.ntp.org
# ntpdate -q time.google.com
if ntpdate -q time.google.com &>/dev/null; then echo OK; fi

# Проверка кода ответа (204 означает успех, 30x — captive portal)
curl -s -o /dev/null -w "%{http_code}" --max-time 5 'http://connectivitycheck.gstatic.com/generate_204'
# 204

curl 'https://www.apple.com/library/test/success.html'
# <HTML><HEAD><TITLE>Success</TITLE></HEAD><BODY>Success</BODY></HTML>

curl 'https://captive.apple.com'
# <HTML><HEAD><TITLE>Success</TITLE></HEAD><BODY>Success</BODY></HTML>

curl -s 'http://www.msftconnecttest.com/connecttest.txt'
# Microsoft Connect Test

curl 'https://ping.archlinux.org'
# This domain is used for connectivity checking (captive portal detection).

curl 'https://nmcheck.gnome.org'
# NetworkManager is online

curl 'https://example.org'
# <!doctype html>......

curl 'https://firefox-portal-detection.com'
# success

