#!/bin/bash
# Простой сменщик обоев для GNOME

WALLPAPER_DIR="$HOME/Изображения/Wallpapers"
if [ "$#" -eq 1 ] && [ -d "$1" ]; then
  WALLPAPER_DIR="$1"
fi
INTERVAL=10  # 10 в секундах
if [ "$#" -eq 2 ] && [ -d "$1" ]; then
  WALLPAPER_DIR="$1"
  INTERVAL="$2"
fi

# Проверяем папку
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Папка $WALLPAPER_DIR отсутствует!" && exit 1
fi

# Проверяем ImageMagick (для определения ориентации)
if ! command -v identify &> /dev/null; then
  echo "Установите ImageMagick" && exit 1
fi

# Функция проверки горизонтальной ориентации с обработкой ошибок
is_horizontal() {
  local file="$1"
    
  # Пробуем получить геометрию
  local geometry=$(identify -format "%wx%h" "$file" 2>/dev/null)
    
  # Если identify failed, пропускаем файл
  if [ $? -ne 0 ] || [ -z "$geometry" ]; then
    return 1
  fi
    
  # Извлекаем ширину и высоту
  local width=${geometry%x*}
  local height=${geometry#*x}
    
  # Проверяем что это числа
  if ! [[ "$width" =~ ^[0-9]+$ ]] || ! [[ "$height" =~ ^[0-9]+$ ]]; then
    return 1
  fi
    
  # Проверяем ориентацию
  [ "$width" -gt "$height" ] && return 0 || return 1
}


# Основной цикл
while true; do
  # Ищем все изображения
  mapfile -t all_wallpapers < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \))
    
  if [ ${#all_wallpapers[@]} -eq 0 ]; then
    echo "Нет обоев в $WALLPAPER_DIR!"
    sleep 10
    continue
  fi

  # Фильтруем только горизонтальные
  horizontal_wallpapers=()
  
  if [ $INTERVAL -ge 10 ]; then
		for wallpaper in "${all_wallpapers[@]}"; do
			if is_horizontal "$wallpaper"; then
				horizontal_wallpapers+=("$wallpaper")
			fi
		done
		# Если нет горизонтальных, используем ВСЕ обои
		if [ ${#horizontal_wallpapers[@]} -eq 0 ]; then
		  echo "Нет горизонтальных обоев! Использую все доступные."
		  horizontal_wallpapers=("${all_wallpapers[@]}")
		fi
	else horizontal_wallpapers=("${all_wallpapers[@]}")
  fi

  # Выбираем случайные горизонтальные обои
  random_wall="${horizontal_wallpapers[RANDOM % ${#horizontal_wallpapers[@]}]}"
    
  # Меняем обои
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$random_wall"
  # gsettings set org.gnome.desktop.background picture-uri-light "file://$random_wall"
    
  echo "$(date '+%H:%M:%S') Установлены: $(basename "$random_wall")"
    
  sleep $INTERVAL
done
