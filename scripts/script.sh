#!/bin/zsh
###################
# $> ./script.sh  #
###################

cat << EOF

  ███████╗  ██████╗ ██████╗  ██╗ ██████╗ ████████╗
  ██╔════╝ ██╔════╝ ██╔══██╗ ██║ ██╔══██╗╚══██╔══╝
  ███████╗ ██║      ██████╔╝ ██║ ██████╔╝   ██║   
  ╚════██║ ██║      ██╔══██╗ ██║ ██╔═══╝    ██║   
  ███████║ ╚██████╗ ██║  ██║ ██║ ██║        ██║   
  ╚══════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝        ╚═╝  

EOF

script_dir="$HOME${${SCRIPTS_DIRECTORY}#*~}"

if [ "$#" -ne 1 ]; then 
  ls --color "${script_dir}"
  exit 0
fi

chr="$1" 
for file in $(ls "${script_dir}"); do
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

echo
cd "${script_dir}"
script=$(echo -en "./${array[${number}]}")
zsh -c "${script} ${params}" 2> /dev/null

