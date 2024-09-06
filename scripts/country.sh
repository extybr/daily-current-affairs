#!/bin/sh

source ~/PycharmProjects/github/daily-current-affairs/scripts/set_get_volume.sh

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
*)
ffplay 'https://strm112.1.fm/country_mobile_mp3?aw_0_req.gdpr=true' -nodisp
;;
esac

clear
