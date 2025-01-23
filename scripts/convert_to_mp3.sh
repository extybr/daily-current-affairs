#!/bin/bash -
# $> ./convert_to_mp3.sh "Sabrina Carpenter - Please Please Please.flac"
# https://trac.ffmpeg.org/wiki/Encode/MP3
# Конвертирует аудио файл в формат mp3

if [ "$#" -ne 1 ] || ! [ -f "$1" ]; then
  exit 1
fi

ffmpeg -i "$1" -codec:a libmp3lame -qscale:a 2 "$1".mp3
echo -e "\e[37m\n Success !!!\n$1.mp3\e[0m\n"

