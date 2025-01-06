#!/bin/sh
#######################
# $> ./country.sh 1   #
# $> ./country.sh m   #
#######################

source ./set_get_volume.sh

tcn_url=${PLAYLIST_DIRECTORY}"/tcn-live.m3u"
radio_country="http://prmstrm.1.fm:8000"

case "$1" in
1)
ffplay "${radio_country}/acountry" -nodisp
;;
2)
ffplay "${radio_country}/ccountry" -nodisp
;;
3)
ffplay "${radio_country}/country" -nodisp
;;
m)
mpv "${tcn_url}"
;;
s)
smplayer "${tcn_url}"
;;
v)
vlc "${tcn_url}"
;;
ss)
smplayer "${tcn_url%"tcn-live.m3u"*}music.m3u"
;;
*)
ffplay 'https://strm112.1.fm/country_mobile_mp3?aw_0_req.gdpr=true' -nodisp
;;
esac

clear

