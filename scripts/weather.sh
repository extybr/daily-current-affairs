#!/bin/sh
printf "\n********************************\n(time: \e[31m%s\e[0m)\n********************************\n" "$(date "+%d-%m-%y_%T")"
curl --connect-timeout 3 wttr.in/Komsomolsk-on-Amur?lang=ru
printf "\n********************************\n(time: \e[31m%s\e[0m)\n********************************\n" "$(date "+%d-%m-%y_%T")"
