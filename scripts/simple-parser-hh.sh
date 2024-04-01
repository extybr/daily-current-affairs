#!/bin/sh
WHITE="\033[37m"
VIOLET="\033[35m"
BLUE="\033[36m"
DBLUE="\033[34m"
YELLOW="\033[1;33m"
NORMAL="\033[0m"
time="&order_by=publication_time"
salary="&only_with_salary=true&salary=$1"
vacancy="&text=инженер%20асу"
pages="&per_page=100"
period="&period=1"
area="&area=113"
if [ $# -ne 1 ]; then echo -e "${WHITE}ожидался 1 параметр, а передано $#${NORMAL}"; exit 1; fi
if ! [ $1 -ge 0 ] 2>/dev/null; then echo -e "${WHITE}ожидалось число${NORMAL}"; exit 1; fi
request=$(curl -s "https://api.hh.ru/vacancies?clusters=true&enable_snippets=true&st=searchVacancy$time$salary$vacancy$pages$period$area")
if [ ${#request} -gt 0 ]
  then
  for page in $(seq 1 100)
  do
  name=$(printf "%s" "$request" | jq -r ".items.[$page].name"); echo -e "${WHITE}$name${NORMAL}" | sed "s/null/--- конец ---/g"
  if [ "$name" = "null" ]; then break; fi
  company=$(printf "%s" "$request" | jq -r ".items.[$page].employer.name"); echo -e "фирма: ${VIOLET}$company${NORMAL}"
  date=$(printf "%s" "$request" | jq -r ".items.[$page].published_at" | sed "s/+.*//g" | tr "T" " ")
  echo -e "дата: ${DBLUE}$date${NORMAL}"
  from=$(printf "%s" "$request" | jq -r ".items.[$page].salary.from")
  to=$(printf "%s" "$request" | jq -r ".items.[$page].salary.to")
  echo -e "зарплата: ${BLUE}$from${NORMAL} - ${BLUE}$to${NORMAL}"
  alternate_url=$(printf "%s" "$request" | jq -r ".items.[$page].alternate_url"); echo -e "ссылка: ${YELLOW}$alternate_url${NORMAL}"
  echo 
  done
fi
