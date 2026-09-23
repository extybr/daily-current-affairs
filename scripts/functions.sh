#!/bin/zsh
# HACK: для применения в файле .zshrc и текущей сессии терминала

# просмотр всех функций
function all/ {
  bat "$HOME/my_programs/function.txt"
}

# автосмена обоев
function wl/ {
  if pgrep auto-wallpaper; then
    pkill -f auto-wallpaper
  fi
  if [ $# -eq 1 ]; then
    if [ "$1" = "k" ]; then
      pkill -f auto-wallpaper
      nohup "${SCRIPTS_DIRECTORY}/auto-wallpaper.sh" k &>/dev/null
    elif [ -d "$1" ]; then
      nohup "${SCRIPTS_DIRECTORY}/auto-wallpaper.sh" "$1" &>/dev/null &
    fi
  elif [ $# -eq 2 ] && [ -d "$1" ]; then
    nohup "${SCRIPTS_DIRECTORY}/auto-wallpaper.sh" "$1" "$2" &>/dev/null &
  elif [ $# -eq 3 ] && [ -d "$1" ]; then
    nohup "${SCRIPTS_DIRECTORY}/auto-wallpaper.sh" "$1" "$2" "$3" &>/dev/null &
  else
    nohup "${SCRIPTS_DIRECTORY}/auto-wallpaper.sh" &>/dev/null &
  fi
}

# функция для git
function gitup {
  if [ -z "$1" ]; then
        echo "❌ Usage: gitup \"commit message\""
        return 1
  fi
  if ! ssh-add -L &>/dev/null; then
    eval "$(ssh-agent -s)" && ssh-add "$HOME/.ssh/extybr"
  fi
  git add . && git commit -m "$1" && git push
}

# функция для veracrypt
function v/ {
  if [ "$#" -ne 2 ] && [ "$#" -ne 3 ]; then
    echo "*** нужно 2 или 3 параметра ***" && return 1
  fi
  "${SCRIPTS_DIRECTORY}/veracrypt.sh" "$@"
}

# убить процессы по названию
function kp/ {
  for pid in $(pgrep "$1"); do
    kill -9 "$pid"
  done
}

# htop с фильтром
function h/ {
  if [ "$#" -eq 1 ]; then
    htop --filter="$1"
  else
    htop --filter='outline|http2|xray|amnezia|hiddify|sing-box|nodpi'
  fi
}

# баланс TTK
function ttk {
  current_dir=$(pwd)
  cd "${GITHUB_DIRECTORY}"/internet_balance
  ./ttk.sh "$@"
  cd "${current_dir}"
}

# баланс RT
function rt {
  current_dir=$(pwd)
  cd "${GITHUB_DIRECTORY}"/internet_balance
  # ./rt.sh "$@"
  uv run rt_playwright_minimal.py
  cd "${current_dir}"
}

# создание и открытие плейлиста alensat
function al/ {
  current_dir=$(pwd)
  trap "echo ' Trapped Ctrl-C'; rm *.m3u && cd "${current_dir}" && return 0" SIGINT
  cd "${GITHUB_DIRECTORY}"/playlist_check/alensat
  ./alensat_playlist.sh "$@"
  rm *.m3u
  cd "${current_dir}"
}

# запуск ffplay с ссылкой
function f/ {
  if (( "$#" == 2 )) && (( "$1" == 0 )); then
    ffplay "$2" -nodisp -volume 3
  elif (( "$#" == 1 )); then
    ffplay "$1" -volume 3
  fi
}

# запуск радио кантри
function cy/ {
  current_dir=$(pwd)
  cd ${SCRIPTS_DIRECTORY}
  if [ "$#" -eq 1 ]; then
    ./country.sh "$1"
  else ./country.sh
  fi
  cd "${current_dir}" 
}

# tracker parser
function tt/ {
  current_dir=$(pwd)
  cd ${TRACKER_PARSER_DIRECTORY}
  if [ "$#" -eq 1 ]; then
    ./main.sh "$1"
  else ./main.sh
  fi
  cd "${current_dir}"
}

# просмотр топа rutor.info
function ri/ {
  current_dir=$(pwd)
  cd "${TRACKER_PARSER_DIRECTORY}"
  ./rutor.sh "$@"
  cd "${current_dir}"
}

# название службы по порту
function p/ {
  grep " $1/" /etc/services | cut -d " " -f1 | sort | uniq
}

# скачивание видео, аудио с ютуба или другого ресурса
function y/ {
  if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo -e "\e[37mНеобходимо передать url-адрес\e[0m"
    return 0
  fi
  ~/bin/yt-dlp -U
  if [ "$#" -eq 2 ] && [ "$2" = 'audio' ]; then
    ~/bin/yt-dlp --js-runtimes node --retries infinite --no-playlist \
    --format bestaudio --extract-audio --audio-format mp3 --embed-thumbnail \
    --windows-filenames --force-overwrites --output '%(title)s.%(ext)s' "$1"  # audio.mp3 + thumbnail
  else ~/bin/yt-dlp --js-runtimes node -S 'res:720,fps' "$1"                                     # video-720p
  # else ~/bin/yt-dlp --proxy http://127.0.0.1:8881 -S 'res:720,fps' "$1"     # video-720p + proxy
    ${SCRIPTS_DIRECTORY}/yt-dlp-rename.py $(pwd)
  fi
}

# серфинг по папкам из терминала
function fz/ {
  # printf '\033[H'  # аналог Ctrl+L
  clear
  item=$(ls -1 -a | fzf --query "$1" --prompt=" $1 " --height=~100% --layout=reverse --border \
                    --preview 'if file --mime-type -b {} 2>/dev/null | grep -q "^image/"; then
                                 viu -b -- {} 2>/dev/null
                               else
                                 bat --style=numbers --color=always {} 2>/dev/null
                               fi' --exit-0)
  if [[ -z "${item}" ]]; then
    echo "Nothing selected"
    return 0
  else
    if [[ -d "${item}" ]]; then
      # xdg-open "${item}"
      # cd "${item}" && fd --type f --hidden --strip-cwd-prefix
      cd "${item}" && fz/
    elif [[ -f "${item}" ]] && ( [[ $(exiftool "${item}" | grep 'MIME Type' | grep -w text) ]] || [[ "${item#*.}" = 'json' ]] ); then
      bat "${item}"
    elif [[ -f "${item}" ]] && [[ "${item}" =~ ('jpg'|'png'|'bmp')$ ]]; then
      if pgrep ghostty; then
        viu "${item}"
      else exiftool "${item}" && xdg-open "${item}"
      fi
    else 
      # echo "\e[36m${item}"
      # ls -lia "${item}" | rg "${item}" && file "${item}"
      exiftool "${item}"
    fi
  fi
}

# серфинг по файлу истории команд терминала
function hi/ {
  printf '\033[H'  # аналог Ctrl+L
  item=$(cat "$HISTFILE" | tac | fzf --query "$1" --prompt=" history " --height=~70% --layout=reverse --border --exit-0)
  echo "${item#*;}"
}

# график, курс криптовалюты с rate.sx
function btc {
  current_dir=$(pwd)
  cd ${SCRIPTS_DIRECTORY}/
  white='\033[1;37m'
  normal='\033[0m'
  if [ "$#" -eq 0 ]
    then curl rate.sx
  elif [ "$#" -eq 1 ]
    then curl rate.sx/"$1"
  else echo -e "${white} Ожидалось не более 1 параметра${normal}"
  fi
  cd "${current_dir}"
}

# запуск приложения
function ctd/ {
  current_dir=$(pwd)
  cd ${GITHUB_DIRECTORY}/connect_to_databases
  venv/bin/python main.py
  cd "${current_dir}"
}

# проверка сертификата сайта
function ssl/ {
  echo | openssl s_client -connect $1:443 | openssl x509 -noout -enddate | grep notAfter
  openssl s_client -connect $1:443 -servername $1 -verify_return_error &> /dev/null \
  && echo -e "*** \033[1;32mДоверенный\033[0m ***" || echo -e "*** \033[1;31mНЕ доверенный\033[0m ***"
}

