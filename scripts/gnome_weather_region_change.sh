#!/bin/bash
# $> ./gnome_weather_region_change.sh
# Правка региона погоды в приложении gnome-weather / https://gitlab.gnome.org/GNOME/gnome-weather
# Текущий основной источник в libgweather — Норвежский метеорологический институт (met.no)

# Название города
city='Комсомольск-на-Амуре'

# Получаем координаты с сервиса nominatim.openstreetmap.org
cd "${SCRIPTS_DIRECTORY}" && source ./coordinates.sh "$city"

# Проверка, что координаты получены
if [[ -z "$lat" || -z "$lon" ]]; then
    echo "Ошибка: не удалось получить координаты для города $city"
    exit 1
fi

# Проверяем результат
echo "$lat"
echo "$lon"

lat=$(echo "$lat" | awk '{printf("%.6f",$1)}')
lon=$(echo "$lon" | awk '{printf("%.6f",$1)}')

# Переводим координаты в радианы
lat_radian=$(echo "$lat * 3.1415926535 / 180" | bc -l)
lon_radian=$(echo "$lon * 3.1415926535 / 180" | bc -l)

# Проверяем результат
echo "$lat_radian"
echo "$lon_radian"

# Для GNOME Weather
gsettings set org.gnome.Weather locations "[<(uint32 2, <(\"$city\", '', true, [($lat_radian, $lon_radian)], @a(dd) [])>)>]"

# Для виджета панели
gsettings set org.gnome.shell.weather locations "[<(uint32 2, <(\"$city\", '', true, [($lat_radian, $lon_radian)], @a(dd) [])>)>]"

# Проверка данных в консоли
gsettings get org.gnome.Weather locations
gsettings get org.gnome.shell.weather locations

echo "✅ Погода для $city установлена"

