#!/bin/sh
WHITE="\033[37m"
VIOLET="\033[35m"
YELLOW="\033[1;33m"
NORMAL="\033[0m"
time="&order_by=publication_time"
salary="&only_with_salary=true&salary=300000"
vacancy="&text=инженер%20асу"
pages="&per_page=100"
period="&period=1"
area="&area=113"
request=$(curl -s "https://api.hh.ru/vacancies?clusters=true&enable_snippets=true&st=searchVacancy$time$salary$vacancy$pages$period$area")
if [ ${#request} -gt 0 ]
  then
  for page in $(seq 1 100)
  do
  name=$(printf "%s" "$request" | jq -r ".items.[$page].name"); echo -e "${WHITE}$name${NORMAL}"
  if [ "$name" = "null" ]; then break; fi
  company=$(printf "%s" "$request" | jq -r ".items.[$page].employer.name"); echo -e "${VIOLET}$company${NORMAL}"
  printf "%s" "$request" | jq -r ".items.[$page].published_at"
  from=$(printf "%s" "$request" | jq -r ".items.[$page].salary.from")
  to=$(printf "%s" "$request" | jq -r ".items.[$page].salary.to")
  echo "зарплата: $from - $to"
  alternate_url=$(printf "%s" "$request" | jq -r ".items.[$page].alternate_url"); echo -e "${YELLOW}$alternate_url${NORMAL}"
  echo
  done
fi
