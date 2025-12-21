#!/bin/bash
# $> ./no-video.sh mp 'http://link'
# Запуск в терминале только аудио потока

set -e

if [ "$#" -ne 2 ]; then
  echo "*** ожидалось 2 параметра ***" && exit 1
fi

link="$2"

check_install() {
  if hash "$1" 2>/dev/null; then
    true
  else echo -e "Программа не установлена: \033[31m$1" && exit
  fi
}

check_path() {
  if [ -f "$1" ]; then
    true
  else echo -e "Программа не найдена: \033[31mphiola" && exit
  fi
}

case "$1" in
  mp) check_install mpv
      mpv --no-video --ytdl-format=worstaudio "$link"
  ;;
  ff) check_install ffplay
      ffplay "$link" -volume 3 -nodisp
  ;;
  mo) check_install mocp
      mocp -S && mocp -l -v 20 "$link"
  ;;
  ph) phiola="$HOME/my_programs/phiola-2/./phiola"
      check_path "$phiola"
      "$phiola" "$link"
  ;;
esac

