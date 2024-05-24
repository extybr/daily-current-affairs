#!/bin/sh
current_folder=$(pwd)
cd ~/PycharmProjects/github/youtube_latest_videos
./rss.sh "$1"
cd "${current_folder}"
