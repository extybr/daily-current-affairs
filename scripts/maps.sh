#!/bin/bash
#########################
# $> ./maps.sh Berlin   #
#########################

blue='\e[36m'
yellow='\e[033m'
normal='\e[0m'

cd ~/PycharmProjects/github/daily-current-affairs/scripts/
echo -e "${blue}"
source ./coordinates.sh "$1"
lat="${coordinates[0]}"
lon="${coordinates[1]}"
size="6000"
echo -ne "${normal}"

revers=($(curl -s "https://nominatim.openstreetmap.org/reverse?lat=${lat}&&lon=${lon}" | \
         grep -oP 'city>[^<]+</|town[^<]+</|country>[^<]+</' | \
         sed 's/<\///g ; s/country//g; s/city//g ; s/town//g ; s/>//g'))
echo -e "\nГород: ${blue}${revers[0]}${normal}\nСтрана: ${blue}${revers[-1]}${normal}\n"

geohack="https://geohack.toolforge.org/geohack.php?language=ru&pagename=${city}\
&params=${lat}_0_0_N_${lon}_0_0_E_region:RU_type:adm2nd"
echo -e "Карты на geohack: ${yellow}${geohack}${normal}\n"

google_map_place="https://www.google.com/maps/place/${city}/@${lat},${lon},${size}m"
echo -e "Google карты: ${yellow}${google_map_place}"
google_map="https://www.google.com/maps/@${lat},${lon},${size}m"
echo -e "${google_map}${normal}\n"

yandex_map="https://yandex.ru/maps/?ll=${lon}%2C${lat}&z=13"
echo -e "Yandex карты: ${yellow}${yandex_map}"
echo -e "https://yandex.ru/maps/?l=sat&ll=${lon}%2C${lat}&z=12${normal}\n"

bing_map="https://www.bing.com/maps?v=2&cp=${lat}%7E${lon}&style=h&lvl=11.0"
echo -e "Bing карты: ${yellow}${bing_map}${normal}\n"

wikipedia_map="https://ru.wikipedia.org/wiki/${city}#/maplink/1"
echo -e "Wikipedia карты: ${yellow}${wikipedia_map}${normal}\n"

acme_map="https://mapper.acme.com/?ll=${lat},${lon}&z=11&t=H&marker0=${lat},${lon}"
echo -e "Acme карты: ${yellow}${acme_map}${normal}\n"

wikimap="https://wikimap.toolforge.org/?wp=false&basemap=2&cluster=false&zoom=11&lat=${lat}&lon=${lon}"
echo -e "Toolforge карты: ${yellow}${wikimap}${normal}\n"

openstreetmap="https://www.openstreetmap.org/?mlat=${lat}&mlon=${lon}&zoom=15#map=14/${lat}/${lon}"
echo -e "Openstreetmap карты: ${yellow}${openstreetmap}"
echo -e "${openstreetmap}&layers=Y${normal}\n"

nakarte_map="https://nakarte.me/#m=12/${lat}/${lon}&l=O&r=${lat}/${lon}/"
city="https://nakarte.me/#m=14/${lat}/${lon}&l=S"
state="https://nakarte.me/#m=13/${lat}/${lon}&l=L"
country="https://nakarte.me/#m=13/${lat}/${lon}&l=I"
echo -e "Nakarte карты: ${yellow}${nakarte_map}\n${city}\n${state}\n${country}${normal}\n"

