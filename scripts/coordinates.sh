#!/bin/bash
#################################
# $> ./coordinates.sh New-York  #
# $> ./coordinates.sh Амурск    #
#################################

city=$(echo $(./url_encoder.py "$1"))
coordinates=($(curl -s "https://nominatim.openstreetmap.org/\
search?q=${city}\&format=jsonv2&addressdetails=1&limit=1" | \
jq -r '.[0].lat, .[0].lon'))
echo "Координаты $1:"
echo "Latitude (широта): ${coordinates[0]}"
echo "Longitude (долгота): ${coordinates[1]}"

