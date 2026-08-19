#!/bin/bash
# $> ./video_url_json.sh https://youtu.be/wjSyUaiXKp0      # вывести данные  (youtube, rutube, vkvideo)
# $> ./video_url_json.sh https://youtu.be/wjSyUaiXKp0 s    # вывести ссылку на субтитры (только для youtube)
# $> ./video_url_json.sh https://youtu.be/wjSyUaiXKp0 s r  # вывести ссылку и прочитать субтитры (только для youtube)
# Данные в json-формате на видео youtube (+субтитры), rutube, vkvideo

# субтитры youtube-видео
if ( [[ "$#" -eq 2 ]] || [[ "$#" -eq 3 ]] ) && [[ "$1" =~ ^('https://youtu'|'https://www.youtu') ]] && [[ "$2" == 's' ]]; then
  sub_url=$($HOME/bin/./yt-dlp --dump-json "$1" 2>/dev/null | jq -r '.automatic_captions.ru.[] | select(.ext == "srt").url')
  echo "$sub_url"
  if [[ "$#" -eq 3 ]] && [[ "$3" == 'r' ]]; then
    # читаем субтитры / начиная с третьей, выводим каждую четвертую строку и склеиваем каждые 4 строки
    echo && curl -s "$sub_url" | awk 'NR%4==3 {s=s? s" "$0: $0; if(++c%4==0){print s; s=""}} END{if(s) print s}'
  fi
  exit 0
fi

example_urls="Пример url-адреса:\nhttps://www.youtube.com/watch?v=wjSyUaiXKp0\nhttps://youtu.be/wjSyUaiXKp0
https://rutube.ru/video/14cf4869765e6c8420b800a01d8f7e49/\nhttps://vkvideo.ru/video-195334327_456241031"

if [[ "$#" -ne 1 ]] || ! [[ "$1" =~ ^('https://youtu'|'https://www.youtu'|'https://rutube.ru/video/'|'https://vkvideo.ru/video-') ]]; then
  echo -e "*** \033[31mНет валидного url-адреса\033[0m ***\n$example_urls" && exit 1
fi

$HOME/bin/./yt-dlp --dump-json "$1" 2>/dev/null | jq

