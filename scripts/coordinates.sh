#!/bin/bash
###################################
# $> ./coordinates.sh 'New York'  #
# $> ./coordinates.sh Амурск      #
###################################

blue='\e[36m'
normal='\e[0m'

city=$(echo $(./url_encoder.py "$1") | sed "s/ /%20/g")
coordinates=$(curl -s "https://nominatim.openstreetmap.org/\
search?q=${city}\&format=jsonv2&addressdetails=1&limit=1")
echo -e "Координаты ${blue}$1${normal}:"
lat=$(echo "${coordinates}" | jq -r '.[0].lat')
lon=$(echo "${coordinates}" | jq -r '.[0].lon')
town=$(echo "${coordinates}" | jq -r '.[0].address.city')
country=$(echo "${coordinates}" | jq -r '.[0].address.country')
echo -e "Latitude (широта): ${blue}${lat}${normal}"
echo -e "Longitude (долгота): ${blue}${lon}${normal}"

