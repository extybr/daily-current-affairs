#!/bin/bash
# $> ./smbmount.sh
# Монтирование сетевой папки (mount.cifs / GVFS/FUSE)

source "$HOME/my_programs/.env.smb"

echo "
login="$login"
password="$password"
ip="$ip"
folder="$folder"
cifsfolder="$cifsfolder"
uid="$UID"
gid="$GID"
"

# mount.cifs - mount using the Common Internet File System (CIFS)
cifs() {
  sudo mkdir -p /mnt/"$cifsfolder"  # создание папки
  sudo mount -t cifs //"$ip"/"$folder" /mnt/"$cifsfolder" -o username="$login",password="$password",uid="$uid",gid="$gid",vers=3.0  # монтирование с логином и паролем
  # sudo umount /mnt/"$cifsfolder"  # размонтирование
}

# GVFS/FUSE через gnome
gvfs() {
  # gio mount smb://"$login":"$password"@"$ip"/"$folder"  # монтирование с логином и паролем
  gio mount smb://"$ip"/"$folder"  # монтирование
  # gio mount -u smb://"$ip"/"$folder"  # размонтирование
  ls /run/user/1000/gvfs/*="$folder"*  # список файлов
}

# проверка доступности ресурса перед монтированием
if ping -c 1 "$ip" &>/dev/null ; then
  # cifs
  gvfs
fi
