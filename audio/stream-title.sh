#!/bin/bash
# $> ./stream-title.sh "http://prmstrm.1.fm:8000/country"
# Название песни в потоке радио

if [ "$#" -ne 1 ]; then
    echo -e '*** \033[31mОжидалась 1 ссылка\033[0m ***' >&2
    exit 1
fi

if ! hash ffmpeg 2>/dev/null && ! hash mpv 2>/dev/null; then
  echo -e '*** Ни одна из программ [\033[31mmpv, ffmpeg\033[0m] не найдена ***' && exit 1
fi

get_title_mpv() {
  timeout 5 mpv --no-video --no-audio --length=1 --ytdl-format=worstaudio --network-timeout=3 "$1" 2>/dev/null \
  | awk -F': +' '/icy-title/ {print $2; exit}'
}

get_title_ffmpeg() {
  ffmpeg -icy 1 -i "$1" -t 2 -f null - 2>&1 \
  | awk -F': +' '/StreamTitle/ {print $2; exit}'
}

title=""

for cmd in get_title_ffmpeg get_title_mpv; do
  title=$($cmd "$1")
  if [ -n "$title" ]; then
    echo -e "\033[36m$title\033[0m" && exit
  fi
done
echo -e '*** \033[31mНазвание трека не найдено\033[0m ***'

