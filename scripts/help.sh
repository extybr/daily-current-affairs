#!/bin/bash
# $> ./help.sh nl
# Поиск справочной информации

echo -ne ' \e[35m1\e[0m   Локальный просмотр в своей папке help
 \e[35m2\e[0m   Удаленный просмотр у себя (github.com/extybr)
 \e[35m3\e[0m   Удаленный просмотр DT (gitlab.com/dwt1)
 \e[35m4\e[0m   Удаленный поиск в DT README (gitlab.com/dwt1/vidman)
 \e[35m5\e[0m   Список файлов в папке help + DT README (gitlab.com/dwt1/vidman)
 \e[35m6\e[0m   cheat.sh
 \e[35m7\e[0m   man / help
Выбор: '

read choice

case "$choice" in
 1) bat ${GITHUB_DIRECTORY}/daily-current-affairs/help/$1* -l sh 2>/dev/null
 ;;
 2) curl -s "https://raw.githubusercontent.com/extybr/daily-current-affairs/refs/heads/main/help/$1.txt" | bat -l sh
 ;;
 3) curl -s "https://gitlab.com/dwt1/vidman/-/raw/main/docs/$1.org?ref_type=heads" | bat -l sh
 ;;
 4) curl -s "https://gitlab.com/dwt1/vidman/-/raw/main/README.org?ref_type=heads" | rg $1
 ;;
 5) ls ${GITHUB_DIRECTORY}/daily-current-affairs/help/ \
    && curl -s "https://gitlab.com/dwt1/vidman/-/raw/main/README.org?ref_type=heads" | bat -l md
 ;;
 6) curl -s cheat.sh/$1
 ;;
 7) man $1 || $1 --help 2>/dev/null || echo -e "\n\e[31mНет справочных данных\e[0m"
 ;;
 *) exit
 ;;
esac

