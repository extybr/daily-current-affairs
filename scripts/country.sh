#!/bin/bash
#######################
# $> ./country.sh 1   #
# $> ./country.sh s   #
#######################
# Запуск радиостанции или плейлиста по выбору

music_url=${PLAYLIST_DIRECTORY}"/music.m3u"

case "$1" in
1)
ffplay "https://stream.revma.ihrhls.com/zc1497" -volume 3 -nodisp
;;
2)
ffplay "https://ais-sa2.cdnstream1.com/1976_128.mp3" -volume 3 -nodisp
;;
3)
ffplay "http://26343.live.streamtheworld.com/977_COUNTRY_SC" -volume 3 -nodisp
;;
v)
vlc "${music_url}"
;;
s)
smplayer "${music_url}"
;;
*)
source ./set_get_volume.sh
ffplay 'https://strm112.1.fm/country_mobile_mp3?aw_0_req.gdpr=true' -nodisp
;;
esac

clear

