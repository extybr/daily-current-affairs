#!/bin/bash
#############################
# $> ./pacs.sh my_program   #
#############################
# Поиск указанной программы с помощью программ pacman/yay/flatpak

if printf "\e[31m%s\e[0m\n" "sudo pacman -Ss $1"; sudo pacman -Ss "$1"; then exit 0; fi
	
if printf "\n\e[31m%s\e[0m\n" "yay -Ss $1"; yay -Ss "$1"; then echo; fi
	
if printf "\e[31m%s\e[0m\n" "flatpak search $1"; flatpak search "$1"; then echo; 

else echo "NOT FOUND: $1"; exit 1; fi

