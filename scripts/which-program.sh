#!/bin/bash
################################
# $> ./which-program.sh echo   #
################################
# Показывает данные о команде/программе с помощью программ type/whatis/which/whereis/.zshrc

white="\033[37m"
normal="\033[0m"

if [ "$#" -ne 1 ]; then
  echo -e "${white} Ожидался 1 параметр, а передано $#${normal}"
  exit 1
fi

if grep --color -E "^alias $1=" ~/.zshrc
  then echo
fi

cmd_type=$(type "$1" 2> /dev/null)
if [ "${cmd_type}" ]; then echo "type: ${cmd_type}" | grep --color "$1"; echo; fi

if whatis -s1:8 -r "^$1" 2>/dev/null | rg "^$1"
  then CMD=$(whatis -s1:8 -r "^$1" 2>/dev/null | rg "^$1" | cut -d " " -f1)
  echo
  for i in ${CMD}
  do
    printf "%s" "which $i: "; which "$i" 2>/dev/null
    printf "%s" "whereis "; whereis "$i" 2>/dev/null
    echo
  done
fi

