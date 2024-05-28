#!/bin/sh
current_folder=$(pwd)
cd ~/PycharmProjects/github/playlist_check/tcncountry
./tcncountry.sh
mv tcncountry.m3u /run/media/tux/Samsung-1TB/Desktop/Radio
cd "${current_folder}"

