#!/bin/bash
# $> ./no-video.sh mp 'http://link'
# Запуск в терминале только аудио потока

set -e

if [ "$#" -ne 2 ]; then
  echo "*** ожидалось 2 параметра ***" && exit 1
fi

link="$2"

case "$1" in
  mp) mpv --no-video --ytdl-format=worstaudio "$link"
  ;;
  ff) ffplay "$link" -volume 3 -nodisp
  ;;
  mo) mocp -S && mocp -l -v 20 "$link"
  ;;
  ph) "$HOME/my_programs/phiola-2/./phiola" "$link"
  ;;
esac

