#!/bin/bash
# $> ./format.sh
# WARNING: Форматирование, выбранного диска

source ./text-color.sh

# функция выбора
function choice {
  output=$(echo -e "$1" | nl | grep -w "$2" | \
           tr -d "[:blank:]" | sed "s/$2//g")
  echo "${output}"
}

function empty {
  if [ -z "$1" ]; then
    exit 0
  fi
}

# выбор утилиты для запуска
utils=''
for util in gparted gnome-disks mkfs; do
  if command -V "${util}" &> /dev/null; then
    utils+="${util}\n"
  fi
done
echo -e "${utils}" | nl
echo -e "${CYAN}Выберите нужное действие:${NORMAL}"
echo -ne "${WHITE}Нажмите цифру:${NORMAL} "
read number
empty "${number}"
action=$(choice "${utils}" "${number}")

if ! [[ "${action}" ]]; then
  exit 0
fi

if [ "${action}" != 'mkfs' ]; then
  "${action}" &> /dev/null
  exit 0
fi

# выбор диска / раздела диска
echo -e "\n${CYAN}Выберите диск${NORMAL}"
# ls /dev/sd* | nl  # вывод дисков
lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS | grep 'sd' | nl
echo -ne "${WHITE}Нажмите цифру:${NORMAL} "
read number
empty "${number}"
cmd=$(lsblk | grep 'sd' | \
      sed 's/^\([^ \t]*\).*/\1/ ; s/└─//g ; s/├─//g')
disk=$(choice "${cmd}" "${number}")
if ! [[ "${disk}" ]]; then
  exit 0
fi

# выбор файловой системы
echo -e "\n${CYAN}Выберите в какую файловую систему"\
        "отформатировать диск?${NORMAL}"
type_fs="ext4\nntfs\nvfat"
echo -e "${type_fs}" | nl
echo -ne "${WHITE}Нажмите цифру:${NORMAL} "
read number
empty "${number}"
fs=$(choice "${type_fs}" "${number}")
if ! [[ "${fs}" ]]; then
  exit 0
fi

# выбор метки диска
echo -ne "\n${WHITE}Название метки диска:${NORMAL} "
read label

# функция форматирования
function format {
  sudo umount /dev/"$1" 2> /dev/null
  if [ "$2" = 'vfat' ]; then
    sudo mkfs."$2" -n "$3" /dev/"$1"
  else
    sudo mkfs."$2" -L "$3" /dev/"$1"
  fi
  # sudo mkdir /tmp/"$3"
  # sudo mount /dev/"$1" /tmp/"$3"
}

# вывод результата выбора
echo -e "\n${MAGENTA}Выбрано:\n Диск: ${YELLOW}${disk}\n"\
        "${MAGENTA}Файловая система: ${YELLOW}${fs}\n"\
        "${MAGENTA}Метка диска: ${YELLOW}${label}${NORMAL}"

if command -V zenity &>/dev/null && ! zenity --question --text="Продолжить?"; then
  exit
fi

# подтверждение, отмена или запуск форматирования
echo -ne "\n${RED}Диск будет отмонтирован, данные при"\
         "форматировании будут удалены.\n${WHITE}Начать"\
         "форматирование? д/н (y/n)${NORMAL}  "
read answer
case "${answer}" in
  [yд])
  format "${disk}" "${fs}" "${label}"
  notify-send "Сообщение" "Диск отформатирован: успешно" --app-name="FormatDisk" -u critical 2>/dev/null
  ;;
  [nн])
  echo -e "${WHITE}Отмена${NORMAL}"
  exit 0
  ;;
  *)
  echo -e "${WHITE}Действие не подтверждено${NORMAL}"
  ;;
esac

