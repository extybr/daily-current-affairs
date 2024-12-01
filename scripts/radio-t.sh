#!/bin/bash
# https://radio-t.com
# $> ./radio-t.sh

blue='\e[36m'
normal='\e[0m'

urls=($(curl -s 'http://feeds.rucast.net/radio-t' | grep -oP 'url="http://cdn.radio-t.com[^>]+'))
url=$(echo "${urls[0]}" | sed 's/url="//g ; s/"\///g')
real_url=$(curl -s -I "${url}" | grep 'Location:' | sed 's/Location: //g')
echo -e "${blue}${real_url}${normal}"

