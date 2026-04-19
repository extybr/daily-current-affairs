#!/bin/bash
# $> ./audio_cover_tag.sh "La Bouche - Sos.mp3" "La Bouche - Sos.jpg"
# Обложка для аудиофайлов mp3, flac

if [ "$#" -ne 2 ]; then
  echo -e "  \033[31mОжидалось 2 параметра.\033[0m
  Пример: ./audio_cover_tag.sh 'file.mp3' 'cover.jpg'" && exit
fi

filename="$1"
cover="$2"
output="output_$filename"

if ! ([ -f "$filename" ] && [ -f "$cover" ]); then
  echo "Не найден файл" && exit 1
fi

if ! [[ "${filename##*.}" =~ (mp3|flac)$ ]]; then
  echo "Файл должен иметь расширения mp3 или flac"
  exit 1
fi

mp3_cover() {
  local base=$(basename "$filename" .mp3)
  ffmpeg -i "$cover" -i "$filename" -c copy -map 0:v -map 1:a -id3v2_version 3 \
  -metadata title="Album $base" -metadata comment="Cover (front)" "$output"
}

flac_cover() {
  local base=$(basename "$filename" .flac)
  ffmpeg -i "$filename" -i "$cover" -map 0:a -map 1:v -c copy \
  -disposition:v attached_pic -metadata:s:v title="Album $base" \
  -metadata:s:v comment="Cover (front)" "$output"
}

if [[ "${filename##*.}" =~ (mp3)$ ]]; then
  mp3_cover
else flac_cover
fi

