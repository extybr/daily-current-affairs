#!/bin/bash
######################################
# $> ./ffmpeg-recursive.sh ~/Video   #
######################################
# Конвертирование всех файлов, с определенными названиями программой ffmpeg

if ! test -d "$1"; then
  echo "*** folder not found ***"
  exit 1
fi

cd "$1"
for file in *.*
  do
    if ! [ $(echo "${file}" | sed -n "/1080.mp4/p; /1080p.mp4/p") ] && [ $(echo "${file}" | sed -n "/.mp4/p") ]
      then new_file=$(echo "${file}" | sed "s/.mp4/-1080p.mp4/g")
      # echo "${file}: ${new_file}"
      ffmpeg -i "${file}" -s 1920x1080 "${new_file}"
      sleep 900
    fi
  done

