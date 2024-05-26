#!/bin/sh
red='\033[31m'
normal='\033[0m'
if [ $# -ne 1 ]; then
  echo -e "${red} 1 parameter was expected, but $# were passed${normal}"
  exit 0
fi
current_folder=$(pwd)
cd ~/PycharmProjects/github/youtube_latest_videos
./rss.sh "$1"
cd "${current_folder}"
