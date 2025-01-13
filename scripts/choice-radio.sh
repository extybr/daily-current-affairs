#!/bin/bash

top40="http://prmstrm.1.fm:8000/top40"
europaplus="http://ep256.hostingradio.ru:8052/europaplus256.mp3"
country="http://prmstrm.1.fm:8000/acountry"

choice=$(zenity --list --width="300" --height="500" --text "Выбор 🎼 🔊 🥁 🎺 🎹" \
         --title "Выбор радио" --column "список" "топ 40" "европа +" "кантри")

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

