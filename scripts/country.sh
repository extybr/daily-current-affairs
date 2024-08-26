#!/bin/sh
source ~/PycharmProjects/github/daily-current-affairs/scripts/set_get_volume.sh
case "$1" in
1)
ffplay 'http://prmstrm.1.fm:8000/acountry' -nodisp
;;
2)
ffplay 'http://prmstrm.1.fm:8000/ccountry' -nodisp
;;
3)
ffplay 'http://prmstrm.1.fm:8000/country' -nodisp
;;
*)
ffplay 'https://strm112.1.fm/country_mobile_mp3?aw_0_req.gdpr=true' -nodisp
;;
esac
clear
