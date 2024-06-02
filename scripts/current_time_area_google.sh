#!/bin/sh
# ./current_time_area_google.sh New-York
time=$(curl -s -A 'Mozilla/5.0 (X11; Linux x86_64; rv:125.0) Gecko/20100101 Firefox/125.0' "https://www.google.com/search?q=current+time+$1" | grep -oP '"3" role="heading">[^<]+' | sed "s/\"3\" role=\"heading\">/\\n/g"); echo -e "\e[31m${time}\e[0m\\n"

