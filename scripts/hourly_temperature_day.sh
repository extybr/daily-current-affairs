#!/bin/bash
# $> ./hourly_temperature_day.sh 'Хабаровск'
# по-часовая температура на текущие сутки
# ATTENTION: timezone=Australia%2FSydne   / для моей timezone

echo "Documentation:
https://open-meteo.com/en/docs
https://github.com/open-meteo/open-meteo
https://github.com/open-meteo/python-requests
# gui program: https://github.com/amit9838/mousam"

cd "$SCRIPTS_DIRECTORY"
echo && source ./coordinates.sh "$1" && echo -e '\n\e[031mпо-часовая температура на текущие сутки\e[0m'
curl -s "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,weather_code&timezone=Australia%2FSydney&forecast_days=1" \
| grep -oP 'temperature_2m":\[\K[^\]]+' | sed 's/,/\n/g' | nl -v 0 -s ' - время | температура - '

