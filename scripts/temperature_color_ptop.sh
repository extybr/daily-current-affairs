#!/bin/bash
####################################
# $> ./temperature_color_ptop.sh   #
####################################
# Показывает температуру CPU и GPU с цветовой раскраской

WHITE="\033[37m"
BLUE="\033[36m"
NORMAL="\033[0m"

GPU=$(nvidia-smi | grep Default | tr -s " " | cut -d " " -f3 | sed "s/C//g")
echo -e "${WHITE}Температура GPU:${NORMAL} ${BLUE}${GPU}${NORMAL}°C"
echo -e "${WHITE}Температура CPU:${NORMAL}"
IFS=$' '
CPU=$(cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input | sed "s/\(.\)..$/.\1°C/")
LABEL=$(cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_label)
paste <(echo -e ${LABEL}) <(echo ${CPU}) | column -s $'\t' -t | rg "\d\d[.]\d"
inxi -s 2>/dev/null | sed -e "s/  System Temperatures: //g" -e "s/mobo: N\/A//g" | rg "\d\d[.]\d"
inxi -c28 -t 2>/dev/null
