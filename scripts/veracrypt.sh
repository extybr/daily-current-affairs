#!/bin/bash
# $> ./veracrypt.sh m d
# Монтирование, размонтирование зашифрованного диска/файла

CMD=''
SOURCE_FILE="${SAMSUNG_DIRECTORY}/other/ProgramHackers/Cryptographers/VeraCrypt/file.dat"
SOURCE_DISK=$(lsblk -lnb -o NAME,SIZE,TYPE | awk '$3=="part" && $2>=500100000000 && $2<=500110000000 {print "/dev/"$1}')
SRC=''
TARGET_PATH=''
TARGET_FOLDER=''
FILES_MANAGER='nautilus'

if [ "$1" = 'm' ] || [ "$1" = 'fix' ]; then
  CMD='--mount'
elif [ "$1" = 'u' ]; then
  CMD='--unmount'
else exit
fi

if [ "$2" = 'f' ]; then
  TARGET_PATH='/mnt/'
  TARGET_FOLDER='veracrypt1'
  SRC="$SOURCE_FILE"
  if ! [ -f "$SOURCE_FILE" ]; then
    echo "файл <$SOURCE_FILE> не найден" && exit
  fi
elif [ "$2" = 'd' ]; then
  TARGET_PATH="/run/media/$USER/"
  TARGET_FOLDER='Samsung-500GB'
  SRC="$SOURCE_DISK"
  if ! [ -d "$TARGET_PATH$TARGET_FOLDER" ]; then
    echo "папка <$TARGET_PATH$TARGET_FOLDER> не найдена" \
    && sudo mkdir "$TARGET_PATH$TARGET_FOLDER" \
    && echo "папка $TARGET_FOLDER создана"
  fi
else exit
fi

function crypt {
  veracrypt $CMD "$SRC" "$TARGET_PATH$TARGET_FOLDER"
  if [ "$CMD" = "--mount" ]; then
    message='Смонтировано:'
  elif [ "$CMD" = "--unmount" ]; then
    message='Размонтировано:'
  fi
  echo "$message $TARGET_PATH$TARGET_FOLDER"
}

crypt

# if [ "$1" = 'm' ]; then
#   $FILES_MANAGER "$TARGET_PATH$TARGET_FOLDER" &> /dev/null
# fi

# Исправление повреждения файловой системы
function fix_disk {
  if ! command -v ntfsfix &> /dev/null; then echo 'ntfs-3g not installed' && return 1; fi
  if ! [ -L /dev/mapper/veracrypt1 ]; then echo "Отсутствует: /dev/mapper/veracrypt1" && return 1; fi
  sudo umount /dev/mapper/veracrypt1
  sudo ntfsfix /dev/mapper/veracrypt1
  sudo mount /dev/mapper/veracrypt1 "$TARGET_PATH$TARGET_FOLDER"
}

if [ "$1" = 'fix' ]; then
  fix_disk && echo "Исправлено и смонтировано: $TARGET_PATH$TARGET_FOLDER"
fi

