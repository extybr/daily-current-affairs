#!/bin/bash
# используется в других скриптах
# раскраска текста

BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
#######################
NORMAL="\033[0m"
BOLD="\033[1m"
SHADOW="\033[2m"
ITALIC="\033[3m"
UNDERLINED="\033[4m"
BLINK="\033[5m"
BORDERED="\033[7m"
STRIKETHROUGH="\033[9m"
#######################
RED_BOLD="\033[1;31m"
GREEN_BOLD="\033[1;32m"
YELLOW_BOLD="\033[1;33m"
RED_BOLD_YELLOW="\033[1;31;103m"
RED_BLINK_YELLOW="\033[5;31;1;103m"
BLUE_BOLD="\033[1;34m"
BLUE_BOLD_ITALIC="\033[1;34m\033[3m"
LIGHT_MAGENTA_BOLD="\033[1;95m"
LIGHT_CYAN_BOLD="\033[1;96m"
WHITE_BOLD="\033[1;37m"
GRAY_BOLD="\033[1;90m"
#######################
T_BOLD=$(tput bold)
T_NORMAL=$(tput sgr0)
T_BLINK=$(tput blink)
T_BEL=$(tput bel)
T_CLEAR=$(tput clear)

