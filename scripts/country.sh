#!/bin/bash
#######################
# $> ./country.sh 1   #
# $> ./country.sh s   #
#######################
# Запуск радиостанции или плейлиста по выбору

music_url=${PLAYLIST_DIRECTORY}"/music.m3u"
radio_country="http://prmstrm.1.fm:8000"

case "$1" in
1)
ffplay "${radio_country}/acountry" -volume 3 -nodisp
;;
2)
ffplay "${radio_country}/ccountry" -volume 3 -nodisp
;;
3)
ffplay "${radio_country}/country" -volume 3 -nodisp
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

