#!/bin/bash
# $> ./films.m3u-update.sh
# Обновление плейлиста FILMS.m3u

m3u="$(curl -s 'https://raw.githubusercontent.com/Dimonovich/TV/refs/heads/Dimonovich/FREE/FILMS.m3u')"
films="${SAMSUNG_DIRECTORY}/Desktop/Radio/FILMS.m3u"
if [ "${#m3u}" -gt 100 ]; then
  echo "$m3u" | tail +13 > "$films"
  sed -i "2i\#EXTINF:-1,         \n$HOME/Видео/Заглушка.mp4" "$films.m3u"
fi

