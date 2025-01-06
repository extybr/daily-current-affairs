#!/bin/zsh

function fm {
  current_dir=$(pwd)
  cd $HOME${${SCRIPTS_DIRECTORY}#*~}
  ./fmedia.sh $*
  cd "${current_dir}" 
}

function cy/ {
  current_dir=$(pwd)
  cd $HOME${${SCRIPTS_DIRECTORY}#*~}
  if [ "$#" -eq 1 ]; then
    ./country.sh "$1"
  else ./country.sh
  fi
  cd "${current_dir}" 
}

function tt/ {
  current_dir=$(pwd)
  cd $HOME${${TRACKER_PARSER_DIRECTORY}#*~}
  if [ "$#" -eq 1 ]; then
    ./main.sh "$1"
  else ./main.sh
  fi
  cd "${current_dir}"
}

function cre/ {
  current_dir=$(pwd)
  cd $HOME${${TRACKER_PARSER_DIRECTORY}#*~}/../youtube_latest_videos
  if [ "$#" -eq 1 ]; then
    python curl_re.py $1
  fi
  cd "${current_dir}"
}

function csh/ {
  current_dir=$(pwd)
  cd $HOME${${TRACKER_PARSER_DIRECTORY}#*~}/../youtube_latest_videos
  if [ "$#" -eq 1 ]; then
   venv/bin/python rss.py $1
  fi
  cd "${current_dir}"
}

function ri/ {
  current_dir=$(pwd)
  cd $HOME${${TRACKER_PARSER_DIRECTORY}#*~}
  if [ "$#" -gt 1 ]; then
    ./rutor.sh "$@"
  else ./rutor.sh 1
  fi
  cd "${current_dir}"
}

function y/ {
  # https://github.com/yt-dlp/yt-dlp#readme
  if [ "$#" -ne 1 ]
    then echo -e "\e[37mНеобходимо передать url-адрес\e[0m"
    return 0
  fi
  ~/bin/yt-dlp -U
  ~/bin/yt-dlp -S 'res:720,fps' "$1"
  $HOME${${SCRIPTS_DIRECTORY}#*~}/yt-dlp-rename.py $(pwd)
}

btc () {
  current_dir=$(pwd)
  cd $HOME/${${SCRIPTS_DIRECTORY}#*~}/
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
  pushd ~/PycharmProjects/github/ytdl &> /dev/null
  venv/bin/python main.py &> /dev/null
  popd &> /dev/null
}

salary() {
cd ~/PycharmProjects/gitlab/salary_analytics
venv/bin/python main.py
git add .; git commit -m "update"; git push
}

