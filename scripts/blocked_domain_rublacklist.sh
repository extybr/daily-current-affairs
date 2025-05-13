#!/bin/bash
# $> ./blocked_domain_rublacklist.sh rutracker.org
# $> ./blocked_domain_rublacklist.sh 1 rutor.info
# https://roskomsvoboda.org, https://reestr.rublacklist.net
# Информация о блокированных доменах

trap "echo ' Trapped Ctrl-C'; exit 0" SIGINT

proxy=''
source "${SCRIPTS_DIRECTORY/'~'/$HOME}"/proxy.sh 1> /dev/null

result=($(python rublacklist.py "$@"))
for url in "${result[@]}"; do
  echo "${url}"
  curl -s --max-time 7 --location ${proxy} -A \
  'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:138.0)' "${url}" | jq
  echo
done

function info() {
  cat << END
  Общая статистика по ведомствам
  https://reestr.rublacklist.net/api/v3/statistics/
  Cписок заблокированных доменов
  https://reestr.rublacklist.net/api/v3/domains/
  Cписок доменов, проксируемых в Censor Tracker
  Censor Tracker проксирует не все сайты из реестра запрещенных сайтов.
  https://reestr.rublacklist.net/api/v3/ct-domains/
  Cписок доменов, заблокированных по DPI
  Сайты, заблокированные без внесения в реестр запрещенных сайтов, т.е с использованием ТСПУ.
  https://reestr.rublacklist.net/api/v3/dpi/
  Список URL-адресов всех доступных записей
  Возвращает JSON с со списком URL-адресов всех доступных записей
  https://reestr.rublacklist.net/api/v3/records/
  Детали записи
  Возвращает JSON с детальными данными записи
  https://reestr.rublacklist.net/api/v3/record/{ID}/
  Cписок IP-адресов
  Находящихся сейчас в реестре
  https://reestr.rublacklist.net/api/v3/ips/
  Выдача содержания реестра на текущий момент
  Данные обновляются каждый день.
  https://reestr.rublacklist.net/api/v3/snapshot/
  Список сайтов, включенных в реестр Организаторов Распространения Информации (ОРИ)
  https://reestr.rublacklist.net/api/v3/disseminators/

  curl -s --location https://reestr.rublacklist.net/api/v3/domains | jq | wc -l
  826096
  curl -s --location https://reestr.rublacklist.net/api/v3/records | jq | wc -l
  1913383
  curl -s --location https://reestr.rublacklist.net/api/v3/ips | jq | wc -l
  324548

  curl -s --location https://reestr.rublacklist.net/api/v3/domains | jq | rg rutor.info

  curl -s --location --proxy localhost:1080 -A \
  "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:138.0)" \
  'https://reestr.rublacklist.net/ru/?status=1&gov=all&date_start=&date_end=&q=rutracker.org' | \
  ./pup '"div.table_td td_site" json{}' | jq
END
}

# info

