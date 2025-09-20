#!/bin/bash
# Простой сменщик обоев для GNOME с кэшированием

WALLPAPER_DIR="$HOME/Изображения/Wallpapers"
INTERVAL=10
ORIENT=''
if [ "$#" -eq 1 ] && [ -d "$1" ]; then
  WALLPAPER_DIR="$1"
elif [ "$#" -eq 2 ] && [ -d "$1" ]; then
  WALLPAPER_DIR="$1"
  INTERVAL="$2"
elif [ "$#" -eq 3 ] && [ -d "$1" ]; then
  WALLPAPER_DIR="$1"
  INTERVAL="$2"
  ORIENT="$3"
fi

# Проверяем папку
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Папка $WALLPAPER_DIR отсутствует!" && exit 1
fi

# Кэш в памяти
declare -A orientation_cache
last_file_count=0

# Функция проверки горизонтальной ориентации с кэшем
is_horizontal() {
  local file="$1"
    
  # Проверяем кэш
  if [[ -v orientation_cache["$file"] ]]; then
    return ${orientation_cache["$file"]}
  fi
    
  # Определяем ориентацию через file
  local info=$(file "$file" 2>/dev/null) 
  local third_field=$(echo "$info" | awk '{print $(NF-2)}')

  # Проверяем третье поле на наличие размеров
  if [[ "$third_field" =~ ([0-9]+)x([0-9]+) ]]; then
    local width="${BASH_REMATCH[1]}"
    local height="${BASH_REMATCH[2]}"
    if [ "$width" -gt "$height" ]; then
      orientation_cache["$file"]=0
      return 0
    else
      orientation_cache["$file"]=1
      return 1
    fi
  fi
    
  # Если не определили - считаем вертикальным
  orientation_cache["$file"]=1
  return 1
}

# Основной цикл
while true; do
  # Ищем все изображения
  mapfile -t all_wallpapers < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) 2>/dev/null)
    
  if [ ${#all_wallpapers[@]} -eq 0 ]; then
    echo "Нет обоев в $WALLPAPER_DIR!"
    exit
  fi

  horizontal_wallpapers=()
    
  if [ "$ORIENT" = 'all' ]; then
    horizontal_wallpapers=("${all_wallpapers[@]}")
  else
    # Фильтруем только горизонтальные используя кэш
    for wallpaper in "${all_wallpapers[@]}"; do
      if is_horizontal "$wallpaper"; then
        horizontal_wallpapers+=("$wallpaper")
      fi
    done
    if [ ${#horizontal_wallpapers[@]} -eq 0 ]; then
      echo "Нет горизонтальных обоев! Использую все доступные."
      horizontal_wallpapers=("${all_wallpapers[@]}")
    fi
  fi

  # Выбираем случайные обои
  random_wall="${horizontal_wallpapers[RANDOM % ${#horizontal_wallpapers[@]}]}"
    
  # Меняем обои
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$random_wall"
  # gsettings set org.gnome.desktop.background picture-uri-light "file://$random_wall"
    
  echo "$(date '+%H:%M:%S') Установлены: $(basename "$random_wall")"
    
  sleep $INTERVAL
done
