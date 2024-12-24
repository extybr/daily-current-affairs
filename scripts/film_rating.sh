#!/bin/bash
# $> ./film_rating.sh 1274452

if [ "$#" -ne 1 ]
	then echo -e "\033[037mожидалось 1 параметр, а передано $#\033[0m"
	exit 1
fi

rating=$(curl -s "https://rating.kinopoisk.ru/$1.xml"; echo)
echo "${rating}" | grep -oP ">[^<]+" | sed 's/^.//'
echo "${rating}" | grep -oE '>[1-9]{1}.[1-9]{1,5}' | sed 's/^.//'
echo "${rating}" | awk -F'[><]' '{for (i=1; i<=NF; i++) if ($i ~ /^[0-9]+\.[0-9]+$/) print $i}'
echo "${rating}" | sed -n 's/.*>\([0-9]\+\.[0-9]\+\)<.*>\([0-9]\+\.[0-9]\+\)<.*/\1\n\2/p'
echo "${rating}" | perl -nle 'print $1 while />(\d+\.\d+)</g'
echo -e "\033[35mhttps://rating.kinopoisk.ru/$1.gif\033[0m"

