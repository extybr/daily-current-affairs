#!/bin/bash
#######################################################
# $> ./github_release_version.sh yt-dlp yt-dlp        #
# $> ./github_release_version.sh ValdikSS GoodbyeDPI  #
#######################################################

user="$1"
repo="$2"
version=($(curl -s "https://github.com/${user}/${repo}/releases" | \
           grep -oP "/${user}/${repo}/releases/tag/[^\"]+\"" | \
           sed 's/\"//g'))
echo "https://github.com${version[0]}"

