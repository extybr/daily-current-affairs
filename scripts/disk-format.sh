#!/bin/bash
# $> ./format.sh

source ./text-color.sh

# функция выбора
function choice {
output=$(echo -e "$1" | nl | grep -w "$2" | \
         tr -d "[:blank:]" | sed "s/$2//g")
echo "${output}"
}

# выбор утилиты для запуска
utils=''
for util in gparted gnome-disks mkfs; do
  if command -V "${util}" &> /dev/null; then
    utils+="${util}\n"
  fi
done
echo -e "${utils}" | nl
echo -e "${blue}Выберите нужное действие:${normal}"
echo -ne "${white}Нажмите цифру:${normal} "
read number
action=$(choice "${utils}" "${number}")

if ! [[ "${action}" ]]; then
  exit 0
fi

if [ "${action}" != 'mkfs' ]; then
  "${action}" &> /dev/null
  exit 0
fi

# выбор диска / раздела диска
echo -e "\n${blue}Выберите диск${normal}"
# ls /dev/sd* | nl  # вывод дисков
lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS | grep 'sd' | nl
echo -ne "${white}Нажмите цифру:${normal} "
read number
cmd=$(lsblk | grep 'sd' | \
      sed 's/^\([^ \t]*\).*/\1/ ; s/└─//g ; s/├─//g')
disk=$(choice "${cmd}" "${number}")
if ! [[ "${disk}" ]]; then
  exit 0
fi

# выбор файловой системы
echo -e "\n${blue}Выберите в какую файловую систему"\
        "отформатировать диск?${normal}"
type_fs="ext4\nntfs\nvfat"
echo -e "${type_fs}" | nl
echo -ne "${white}Нажмите цифру:${normal} "
read number
fs=$(choice "${type_fs}" "${number}")
if ! [[ "${fs}" ]]; then
  exit 0
fi

# выбор метки диска
echo -ne "\n${white}Название метки диска:${normal} "
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
echo -e "\n${violet}Выбрано:\n Диск: ${yellow}${disk}\n"\
        "${violet}Файловая система: ${yellow}${fs}\n"\
        "${violet}Метка диска: ${yellow}${label}${normal}"

# подтверждение, отмена или запуск форматирования
echo -ne "\n${red}Диск будет отмонтирован, данные при"\
         "форматировании будут удалены.\n${white}Начать"\
         "форматирование? д/н (y/n)${normal}  "
read answer
case "${answer}" in
  [yд])
  format "${disk}" "${fs}" "${label}"
  ;;
  [nн])
  echo -e "${white}Отмена${normal}"
  exit 0
  ;;
  *)
  echo -e "${white}Действие не подтверждено${normal}"
  ;;
esac

