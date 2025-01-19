#!/bin/bash
# $> ./choice-radio.sh
set -e

top40="http://prmstrm.1.fm:8000/top40"
europaplus="http://ep256.hostingradio.ru:8052/europaplus256.mp3"
country="http://prmstrm.1.fm:8000/acountry"

if ! command -V zenity &> /dev/null; then 
  echo -e "*** Command 'zenity' not found ***"
  exit 0
fi

choice=$(zenity --list --width="300" --height="500" --text "Выбор 🎼 🔊 🥁 🎺 🎹" \
         --title "Выбор радио" --column "список" "топ 40" "европа +" "кантри")

level=$(zenity --scale --text="Уровень громкости")

source ./set_get_volume.sh "-->" "${level}%"

case "$choice" in
  'топ 40')
  ffplay "$top40" -nodisp
  ;;
  'европа +')
  ffplay "$europaplus" -nodisp
  ;;
  кантри)
  ffplay "$country" -nodisp
  ;;
esac

