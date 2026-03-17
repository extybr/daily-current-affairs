#!/bin/bash
# $> ./efi_backup_restore.sh
# Бэкап / Восстановление раздела с EFI

# определяем раздел с EFI
efi_point=$(lsblk -lpo NAME,MOUNTPOINTS | grep efi | awk '{print $1}')

# backup_img="efi_backup_$(date +%Y%m%d).img"  # название образа с датой создания
backup_img="efi_backup.img"  # название образа

backup() {
  # бэкап раздела с EFI
  sudo dd if="$efi_point" of="$backup_img" bs=1M
  # sudo dd if="$efi_point" bs=1M | gzip > "$backup_img".gz  # сжатый образ
}

restore() {
  # восстановление раздела из образа
  sudo dd if="$backup_img" of="$efi_point" bs=1M
  # gunzip -c "$backup_img".gz | sudo dd of="$efi_point" bs=1M  # сжатый образ
}

information() {
  # дополнительная информация по разделу
  efibootmgr -v | grep Boot | sed 's/HD.*//g' && echo && \
  sudo fdisk -l | grep -i efi && echo && sudo bootctl | tail -n 100
}

message() {
  echo -e "\n\e[1;36mSuccess\e[0m\n"
}

echo -ne "Выберите действие\n1. Бэкап раздела\n2. Восстановление раздела
3. Дополнительная информация по разделу EFI\n4. Отмена\nВыбор: "
while read -sN1 choice; do
  case "$choice" in
  1) echo "Бэкап" && backup && message && break
    ;;
  2) echo "Восстановление" && restore && message && break
    ;;
  3) echo -e "Информация\n" && information && break
    ;;
  4) echo "Отмена" && break
    ;;
  *) echo -ne "\nНажмите 1, 2, 3 или 4: "
    ;;
  esac
done

