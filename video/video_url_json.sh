#!/bin/bash
# $> ./video_url_json.sh https://youtu.be/wjSyUaiXKp0
# $> ./video_url_json.sh https://youtu.be/wjSyUaiXKp0 s
# Данные в json-формате на видео youtube (+субтитры опционально), rutube, vkvideo

# субтитры youtube-видео
if [[ "$#" -eq 2 ]] && [[ "$1" =~ ^('https://youtu'|'https://www.youtu') ]] && [[ "$2" == 's' ]]; then
  $HOME/bin/./yt-dlp --dump-json "$1" 2>/dev/null \
  | jq -r '.automatic_captions.ru.[] | select(.ext == "srt").url'
  exit 0
fi

example_urls="Пример url-адреса:\nhttps://www.youtube.com/watch?v=wjSyUaiXKp0\nhttps://youtu.be/wjSyUaiXKp0
https://rutube.ru/video/14cf4869765e6c8420b800a01d8f7e49/\nhttps://vkvideo.ru/video-195334327_456241031"

if [[ "$#" -ne 1 ]] || ! [[ "$1" =~ ^('https://youtu'|'https://www.youtu'|'https://rutube.ru/video/'|'https://vkvideo.ru/video-') ]]; then
  echo -e "*** \033[31mНет валидного url-адреса\033[0m ***\n$example_urls" && exit 1
fi

$HOME/bin/./yt-dlp --dump-json "$1" 2>/dev/null | jq

