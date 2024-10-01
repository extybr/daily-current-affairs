#!/bin/zsh
###################
# $> ./script.sh  #
###################

if [ "$#" -ne 1 ]; then 
  ls "$HOME${${SCRIPTS_DIRECTORY}#*~}"
  exit 0
fi

chr="$1" 
for file in $(ls "$HOME${${SCRIPTS_DIRECTORY}#*~}"); do
  slice=${${file}#*$chr}
  if (( "${#slice}" <  "${#file}" )); then
    array+=("${file}\n")
  fi
done

echo -en "${array}" | nl

echo -en "Скрипт под каким номером запустить и с какими параметрами \
(опционально)$(tput blink) =>: \e[0m"
read number params

if [[ ! "${number}" || "${number}" -gt "${#array}" ]]; then
  exit 0
fi

script=$(echo -en "${SCRIPTS_DIRECTORY}/${array[${number}]}")
zsh -c "${script} ${params}" 2> /dev/null

