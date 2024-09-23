#!/bin/sh
##################################
# $> ./my_ip_address_google.sh   #
##################################

user_agent='Mozilla/5.0 (X11; Linux x86_64; rv:125.0) Gecko/20100101 Firefox/125.0'
ip=$(curl -s -A "${user_agent}" 'https://www.google.com/search?q=my+ip+address' | \
     grep -oP ':20px">[^<]+' | sed "s/:20px\">/\\n/g")
echo -e "\e[31m${ip}\e[0m\\n"

