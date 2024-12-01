#!/bin/bash

violet="\e[35m"
blue="\e[36m"
yellow="\e[33m"
white="\e[37m"
normal="\e[0m"

if ! command -V jq &> /dev/null; then echo 'Программа jq не установлена'; exit 0; fi
if ! command -V yq &> /dev/null; then echo 'Программа yq не установлена'; exit 0; fi

current_version=$(cat ~/.config/Outline/sentry/session.json 2> /dev/null | jq -r '.attrs.release')
if [ "${current_version}" ]; then echo -e "Текущая версия: ${blue}${current_version}${normal}\n"; fi

amazonaws='https://s3.amazonaws.com/outline-releases/client/linux/stable/Outline-Client.AppImage'

link=${amazonaws%"client"*}

echo -e "Данные с ${yellow}${link}${normal}"

yml=($(curl -s "${link}client/linux/latest-linux.yml" | yq -r '.version, .path, .releaseDate'))
echo -e "Версия: ${blue}${yml[0]}${normal}"
echo -e "Дата релиза: ${violet}$(date --date=${yml[2]})${normal}"
echo -e "Ссылка: ${blue}${yml[1]}${normal}"
echo -e "Ссылка (2): ${blue}${amazonaws}${normal}"

versions=($(curl -s "https://github.com/Jigsaw-Code/outline-sdk/releases" | \
            grep -oP "/Jigsaw-Code/outline-sdk/releases/tag/[^\"]+\""))
version=$(echo ${versions[0]} | sed 's/\/Jigsaw-Code\/outline-sdk\/releases\/tag\///g ; s/\"//g')
echo -e "\nПоследняя версия ${violet}Outline SDK${normal} - ${blue}${version}${normal}"
echo -e "Ссылка: ${blue}https://github.com/Jigsaw-Code/outline-sdk/releases/tag/${version}${normal}"

archlinux="https://aur.archlinux.org/packages/outline-client-appimage"
echo -e "\nДанные с ${yellow}${archlinux}${normal}"

client=$(curl -s "${archlinux}" | grep -oP 'outline-client-appimage[^<]+</h' | sed 's/<\/h//g')
echo -e "Клиент: ${blue}${client}${normal}"

version_file=$(curl -s "${archlinux}" | grep -oP "<a href=\"${amazonaws}\">[^>]+</a" | sed "s/<\/a//g")
echo -e "Выложенный файл: ${blue}${version_file#*"\">"}${normal}"

dt=($(curl -s "${archlinux}" | grep -oP '<td>[^<]+(UTC)' | sed 's/<td>//g ; s/ (UTC//g'))
echo -e "Первая публикация релиза: ${violet}${dt[0]} ${dt[1]}${normal}"
echo -e "Последняя публикация релиза: ${violet}${dt[2]} ${dt[3]}${normal}"

source /etc/os-release; if ! [ $(echo "${ID_LIKE}") = 'arch' ]; then exit 0; fi

echo -e "\n${white}Установить клиент outline? n/y"
echo -en "Ответ$(tput blink):${normal} "
read answer
if [ "${answer}" = 'y' ]; then
  pkill outline-apps 2> /dev/null
  git clone 'https://aur.archlinux.org/outline-client-appimage.git'
  cd outline-client-appimage
  makepkg -si
else exit 0
fi

