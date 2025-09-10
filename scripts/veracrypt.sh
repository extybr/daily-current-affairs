#!/bin/bash
# $> ./veracrypt.sh m d
# Монтирование, размонтирование зашифрованного диска/файла

CMD=''
SOURCE_FILE="${SAMSUNG_DIRECTORY}/other/ProgramHackers/Cryptographers/VeraCrypt/lsm.dat"
SOURCE_DISK=$(lsblk -lnb -o NAME,SIZE,TYPE | awk '$3=="part" && $2>=500100000000 && $2<=500110000000 {print "/dev/"$1}')
SRC=''
TARGET_PATH=''
TARGET_FOLDER=''
FILES_MANAGER='nautilus'

if ! [ -f "$SOURCE_FILE" ]; then
  echo "<$SOURCE_FILE> не найден" && exit
fi

if [ "$1" = 'm' ]; then
  CMD='--mount'
elif [ "$1" = 'u' ]; then
  CMD='--unmount'
else exit
fi

if [ "$2" = 'f' ]; then
  TARGET_PATH='/mnt/'
  TARGET_FOLDER='veracrypt1'
  SRC="$SOURCE_FILE"
elif [ "$2" = 'd' ]; then
  TARGET_PATH="/run/media/$USER/"
  TARGET_FOLDER='Samsung-500GB'
  SRC="$SOURCE_DISK"
else exit
fi

function crypt {
  veracrypt $CMD "$SRC" "$TARGET_PATH$TARGET_FOLDER"
}

crypt

if [ "$1" = 'm' ]; then
  $FILES_MANAGER "$TARGET_PATH$TARGET_FOLDER" &> /dev/null
fi
