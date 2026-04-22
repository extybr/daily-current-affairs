#!/bin/bash
##############################
# $> ./temperature_ptop.sh   #
##############################
# Показывает температуру CPU и GPU

temperature () {
  GPU=$(nvidia-smi | grep Default | awk '{print $3}' | sed "s/C//g")
  echo -e "Температура GPU: \033[36m${GPU}\033[0m°C"
  echo -e "Температура CPU:"
  IFS=$' '
  CPU=$(cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_input 2> /dev/null | sed "s/\(.\)..$/.\1°C/")
  LABEL=$(cat /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp*_label 2> /dev/null)
  paste <(echo -e ${LABEL}) <(echo ${CPU}) | column -s $'\t' -t  | rg "\d\d[.]\d"
  inxi -s 2> /dev/null | sed -e "s/  System Temperatures: //g" -e "s/mobo: N\/A//g" | rg "\d\d[.]\d"
  inxi -t 2> /dev/null
}

temperature

