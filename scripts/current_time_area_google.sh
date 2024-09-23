#!/bin/sh
############################################
# ./current_time_area_google.sh New-York   #
############################################

user_agent="Mozilla/5.0 (X11; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0"
time=$(curl -s -A "${user_agent}" "https://www.google.com/search?q=current+time+$1" | \
grep -oP '"3" role="heading">[^<]+' | sed "s/\"3\" role=\"heading\">/\\n/g")
echo -e "\e[31m${time}\e[0m\n"
curl -I 'https://google.com' 2>&1 | grep date  # date (GMT) from google

