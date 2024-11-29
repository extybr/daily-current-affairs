#!/bin/bash

violet="\e[35m"
blue="\e[36m"
red="\e[31m"
normal="\e[0m"
for type in film series; do 
  echo -e "${red}Популярные ${type}"
  title_film=$(curl -s "https://kinobox.tv/api/films/popular?type=${type}")
  for number in {0..49}; do 
    title=$(echo -n "${title_film}" | jq -r ".[$number].title")
    id=$(echo -n "${title_film}" | jq -r ".[$number].id")
    echo -e "${blue}${title}: ${violet}https://kinomix.web.app/#${id}"
    done
  done
echo -ne "${normal}"

