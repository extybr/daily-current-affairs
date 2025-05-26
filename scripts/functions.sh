#!/bin/zsh
# HACK: для применения в файле .zshrc и текущей сессии терминала

function kp/ {
  for pid in $(pgrep "$1"); do
    kill -9 "$pid"
  done
}

function x/ {
  if (( "$#" > 0 )) && [ "$1" = 'k' ]; then
    # "${SCRIPTS_DIRECTORY}/xray_key_change.sh"
    echo '*** изменение ключей отключено ***'
  elif (( "$#" == 1 )) && [[ "$1" =~ ^(vless://) ]]; then
    "${SCRIPTS_DIRECTORY}/xray_config_fix.sh" "$1"
    "${SCRIPTS_DIRECTORY}/xray-service-fix.sh"
  else
    source "${SCRIPTS_DIRECTORY}/xray_key_name.sh"
    echo -n "xray: "
    python "${SCRIPTS_DIRECTORY}/url_coder.py" decoder "${key_name}"
    prefix="&prefix=%16%03%01%00%C2%A8%01%01#"
    source "$HOME/my_programs/outline-sdk/outline.key"
    o_key_name=$(echo "${outline_key}" | \
                 grep -oP "${prefix}[^>]+" | \
                 sed "s/${prefix}//")
    echo -n "outline: "
    python "${SCRIPTS_DIRECTORY}/url_coder.py" decoder "${o_key_name}"
  fi
}

function h/ {
  if [ "$#" -eq 1 ]; then
    htop --filter="$1"
  else
    htop --filter='outline|http2|xray|amnezia'
  fi
}

function ttk {
  current_dir=$(pwd)
  cd "${SCRIPTS_DIRECTORY}"/internet_balance
  ./balance_ttk.sh "$@"
  cd "${current_dir}"
}

function f/ {
  if (( "$#" == 2 )) && (( "$1" == 0 )); then
    ffplay "$2" -nodisp -volume 3
  elif (( "$#" == 1 )); then
    ffplay "$1" -volume 3
  fi
}

function cy/ {
  current_dir=$(pwd)
  cd ${SCRIPTS_DIRECTORY}
  if [ "$#" -eq 1 ]; then
    ./country.sh "$1"
  else ./country.sh
  fi
  cd "${current_dir}" 
}

function tt/ {
  current_dir=$(pwd)
  cd ${TRACKER_PARSER_DIRECTORY}
  if [ "$#" -eq 1 ]; then
    ./main.sh "$1"
  else ./main.sh
  fi
  cd "${current_dir}"
}

function cre/ {
  current_dir=$(pwd)
  cd ${GITHUB_DIRECTORY}/youtube_latest_videos
  [[ "$#" -eq 1 ]] && python curl_re.py $1
  cd "${current_dir}"
}

function csh/ {
  current_dir=$(pwd)
  cd ${GITHUB_DIRECTORY}/youtube_latest_videos
  [[ "$#" -eq 1 ]] && venv/bin/python rss.py $1
  cd "${current_dir}"
}

function ri/ {
  current_dir=$(pwd)
  cd "${TRACKER_PARSER_DIRECTORY}"
  ./rutor.sh "$@"
  cd "${current_dir}"
}

function p/ {
  grep " $1/" /etc/services | cut -d " " -f1 | sort | uniq
}

function y/ {
  # https://github.com/yt-dlp/yt-dlp#readme
  if [ "$#" -ne 1 ]
    then echo -e "\e[37mНеобходимо передать url-адрес\e[0m"
    return 0
  fi
  ~/bin/yt-dlp -U
  ~/bin/yt-dlp -S 'res:720,fps' "$1"
  ${SCRIPTS_DIRECTORY}/yt-dlp-rename.py $(pwd)
}

function hx/ {
  item=$(dir -1 | fzf --prompt=" helix  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z "${item}" ]]; then
    echo "Nothing selected"
    return 0
  else
    helix "${item}"
  fi
}

btc () {
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

ytdl() {
  pushd ${GITHUB_DIRECTORY}/ytdl &> /dev/null
  venv/bin/python main.py &> /dev/null
  popd &> /dev/null
}

function ctd/ {
  current_dir=$(pwd)
  cd ${GITHUB_DIRECTORY}/connect_to_databases
  venv/bin/python main.py
  cd "${current_dir}"
}

backup() {
  current_dir=$(pwd)
  cd ${GITLAB_DIRECTORY}/backup
  venv/bin/python main.py
  git add .; git commit -m "update"; git push
  cd "${current_dir}"
}

