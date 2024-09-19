#!/bin/bash

violet="\e[35m"
blue="\e[36m"
yellow="\e[33m"
white="\e[37m"
normal="\e[0m"

amazonaws='https://s3.amazonaws.com/outline-releases/client/linux/stable/Outline-Client.AppImage'

link=${amazonaws%"client"*}

echo -e "Данные с ${yellow}${link}${normal}"

yml=($(curl -s "${link}client/linux/latest-linux.yml" | yq -r '.version, .path, .releaseDate'))
echo -e "Версия: ${blue}${yml[0]}${normal}"
echo -e "Дата релиза: ${violet}$(date --date=${yml[2]})${normal}"
echo -e "Ссылка: ${blue}${yml[1]}${normal}"

archlinux="https://aur.archlinux.org/packages/outline-client-appimage"
echo -e "\nДанные с ${yellow}${archlinux}${normal}"

client=$(curl -s "${archlinux}" | grep -oP 'outline-client-appimage[^<]+</h' | sed 's/<\/h//g')
echo -e "Клиент: ${blue}${client}${normal}"

version_file=$(curl -s "${archlinux}" | grep -oP "<a href=\"${amazonaws}\">[^>]+</a" | sed "s/<\/a//g")
echo -e "Выложенный файл: ${blue}${version_file#*"\">"}${normal}"

dt=($(curl -s "${archlinux}" | grep -oP '<td>[^<]+(UTC)' | sed 's/<td>//g ; s/ (UTC//g'))
echo -e "Первая публикация: ${violet}${dt[0]} ${dt[1]}${normal}"
echo -e "Последняя публикация: ${violet}${dt[2]} ${dt[3]}${normal}"

echo -e "${white}Установить клиент outline? n/y${normal}"
read answer
if [ "${answer}" = 'y' ]; then
  #pkill outline
  git clone 'https://aur.archlinux.org/outline-client-appimage.git'
  cd outline-client-appimage
  makepkg -si
else exit 0
fi

