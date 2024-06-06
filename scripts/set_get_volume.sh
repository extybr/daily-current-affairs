#!/bin/sh
current_volume=$(amixer get Master | grep 'Front Left:' | tr -d " " | cut -d '[' -f 2 | sed 's/%]//g')

set_volume() {
amixer cset iface=MIXER,name="Master Playback Volume" "${current_volume}"% &> /dev/null
}

trap "set_volume; exit 0" exit
amixer cset iface=MIXER,name="Master Playback Volume" 20% &> /dev/null
