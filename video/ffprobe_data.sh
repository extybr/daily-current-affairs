#!/bin/bash
# ffprobe параметры видеофайла для Nautilus

term() {
  terminator -g $HOME/.config/terminator/config --new-tab -e \
  "echo -e \"\n***** \033[36m$1\033[0m *****\n\"; \
  ffprobe -v error -show_entries stream=codec_name,codec_type,width,height,r_frame_rate,sample_rate,channels,pix_fmt \
  -of default=noprint_wrappers=1:nokey=0 \"$1\"; echo && zsh"
}

zen() {
  # ffprobe -pretty "$1"
  # ffprobe -v quiet -print_format json -show_format -show_streams "$1" | jq '.'
  # ffprobe -v quiet -show_format -show_streams "$1"
  # ffprobe -v error -show_entries stream=codec_name,width,height,r_frame_rate,bitrate -show_entries format=bitrate "$1"
  # ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,width,height,r_frame_rate,pix_fmt -of default=noprint_wrappers=1 "$1"
  result=$(ffprobe -v error -show_entries stream=codec_name,codec_type,width,height,r_frame_rate,sample_rate,channels,pix_fmt \
           -of default=noprint_wrappers=1:nokey=0 "$1")
  zenity --info --title="$1" --text="$result"
}

exf() {
  info=$(exiftool "$1" | grep -E \
  "File Size|File Permissions|File Type  |^MIME Type|Doc Type|^Duration  |\
Video Codec ID|Video Frame Rate|Image Width|Image Height|Display Width|Display Height|\
Audio Codec ID|Audio Sample Rate|Audio Channels|Track Language  |Image Size|Megapixels|\
Sample Rate|Channel Mode|Audio Bitrate")
  zenity --info --title="$1" --text="$info" --width=500 --height=400
}

# term "$1"
# zen "$1"
exf "$1"
