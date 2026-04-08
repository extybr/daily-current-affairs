#!/bin/bash
# Проверка и монтирование проблеммного зашифрованного диска

SOURCE_DISK=$(lsblk -lnb -o NAME,SIZE,TYPE | awk '$3=="part" && $2>=500100000000 && $2<=500110000000 {print "/dev/"$1}')
SOURCE_PATH='/dev/mapper/'
TARGET_PATH='/mnt/'
TARGET_FOLDER='veracrypt1'

disk_mount_fs_none() {
  # Открытие тома без монтирования
  veracrypt --mount "$SOURCE_DISK" --filesystem=none
}

disk_check_and_fix() {
  # Проверка - после открытия тома (но до монтирования):
  sudo ntfsfix "$SOURCE_PATH$TARGET_FOLDER"

  # Сбросить флаг принудительной проверки
  # sudo ntfsfix -b /dev/mapper/veracrypt1

  # Или более агрессивно:
  sudo ntfsfix -b -d "$SOURCE_PATH$TARGET_FOLDER"

  # Проверка монтируемости тома (без реального монтирования) / Проверка статуса
  sudo ntfs-3g.probe --readwrite "$SOURCE_PATH$TARGET_FOLDER"
}

disk_check_fix_headerbak() {
  # Попробуем смонтировать с резервным заголовком
  veracrypt --mount "$SOURCE_DISK" "$TARGET_PATH$TARGET_FOLDER" --mount-options=headerbak

  # Восстанавливаем заголовок (будет интерактивный запрос)
  veracrypt --restore-headers "$SOURCE_DISK"

  # Монтирование с минимальными опциями
  veracrypt --mount "$SOURCE_DISK" "$TARGET_PATH$TARGET_FOLDER" --fs-options="noatime"
}

disk_mount() {
  # Принудительное монтирование через стандартный mount
  sudo mount -t ntfs-3g "$SOURCE_PATH$TARGET_FOLDER" "$TARGET_PATH$TARGET_FOLDER" -o remove_hiberfile,force,big_writes,noatime
}

disk_unmount() {
  # Размонтирование
  sudo umount "$TARGET_PATH$TARGET_FOLDER"
}

disk_mount_fs_none
disk_check_and_fix
# disk_check_fix_headerbak
disk_mount
# disk_unmount

