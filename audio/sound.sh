#!/bin/bash
# $> ./sound.sh
# Установка уровней громкости динамиков и микрофона. Запись и воспроизведение записанного файла
# FAQ: запускаем скрипт -> говорим в микрофон -> Ctrl+C -> слушаем записанное аудио

trap "set_volume; exit 0" exit

level="35%"  # желаемый уровень громкости динамиков

# запоминаем текущий уровень громкости динамиков
current_volume=$(amixer get Master | grep 'Front Left:' | tr -d " " | cut -d '[' -f 2 | sed 's/]//g')

set_volume() {
  # возвращаем текущий уровень громкости динамиков после завершения работы скрипта
  amixer -D pulse sset Master "${current_volume}" &> /dev/null
}

# установка нужного уровня громкости динамиков
amixer -D pulse sset Master "${level}" &> /dev/null

# установка нужного уровня микрофона
pactl set-source-volume @DEFAULT_SOURCE@ "${level}" 2>/dev/null

# запись звука (настройки оптимизировал для своего микрофона)
arecord -D plughw:1,0 -f FLOAT_LE -r 44100 -c 1 --disable-resample my-sound-file.wav 2>/dev/null

# определяем дефолтную аудио карту
card=$(aplay -L | grep -E "sysdefault:CARD=" | sed 's/sysdefault:CARD=//')

# воспроизведение записанного аудио файла
aplay -D sysdefault:CARD="$card" my-sound-file.wav

