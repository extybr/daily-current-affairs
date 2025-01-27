#!/bin/bash
##################################
# $> ./my_ip_address_google.sh   #
##################################
# Парсинг ip-адреса устройства с сайта google.com

# FIXME: not working now
user_agent='Mozilla/5.0 (X11; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0'
ip=$(curl -A "${user_agent}" 'https://www.google.com/search?q=my+ip+address' | \
     grep -oP ':20px">[^<]+' | sed "s/:20px\">/\\n/g")
echo -e "\e[31m${ip}\e[0m\\n"

