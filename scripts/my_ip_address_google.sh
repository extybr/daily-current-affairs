#!/bin/sh
ip=$(curl -s -A 'Mozilla/5.0 (X11; Linux x86_64; rv:125.0) Gecko/20100101 Firefox/125.0' 'https://www.google.com/search?q=my+ip+address' | grep -oP ':20px">[^<]+' | sed "s/:20px\">/\\n/g"); echo -e "\e[31m${ip}\e[0m\\n"
