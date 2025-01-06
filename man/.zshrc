# Use powerline
USE_POWERLINE="true"
# Has weird character width
# Example:
#    is not a diamond
HAS_WIDECHARS="false"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

#https://www.geeksforgeeks.org/histcontrol-command-in-linux-with-examples/
#HISTCONTROL=ignoreboth:erasedups

#/usr/share/zsh/manjaro-zsh-config
HISTSIZE=20000
SAVEHIST=20000

# Disable autocorrect
# unsetopt correct_all
unsetopt correct

export wlan0='wlp3s0'
export wlan1='wlp0s20f0u1u4'
export SCRIPTS_DIRECTORY='~/PycharmProjects/github/daily-current-affairs/scripts'
export TRACKER_PARSER_DIRECTORY='~/PycharmProjects/github/tracker_parser'
export SAMSUNG_DIRECTORY='/run/media/tux/Samsung-1TB'
export PLAYLIST_DIRECTORY="${SAMSUNG_DIRECTORY}/Desktop/Radio"
alias ip='ip --color'
alias gitu='git add . && git commit -m'
alias reqrypt=${SCRIPTS_DIRECTORY}'/./reqrypt-1.3.1-linux64.sh'
alias sampler='sampler -c ~/my_programs/config.yml'
alias pspy='~/my_programs/./pspy64'
alias cm/='cmatrix -r'
alias mocp='mocp -T /usr/share/moc/themes/darkdot_theme'
alias gpgd='gpg -d ${SAMSUNG_DIRECTORY}/mail.txt.gpg'
alias gpgd/='gpgd | rg -A10 -B5 $1'
alias wr/=${SCRIPTS_DIRECTORY}'/weather.sh'
alias sl/=${SCRIPTS_DIRECTORY}'/sl.sh'
alias os/=${SCRIPTS_DIRECTORY}'/os.sh'
alias pac='sudo pacman -S'
alias pacs=${SCRIPTS_DIRECTORY}'/pacs.sh'
# /usr/share/cows
alias tux='cowsay -f tux LINUX - Good !!!'
alias bsd='echo "\e[31m$(cowsay -f daemon Отдавай все свои биткоины !!!)"'
alias dragon='echo "\e[35m$(cowsay -f dragon-and-cow Тебя поджарить\?)"'
alias wf/="${SCRIPTS_DIRECTORY}/wifi_start.sh"
alias myssh="bash -c 'cd ~/PycharmProjects/github/remote_control && sudo ./start.sh'"
alias mpeg='bash -c "cd ~/PycharmProjects/github/ffmpeg_gui && ./start_linux.sh"'
alias map=${SCRIPTS_DIRECTORY}'/map.sh'
alias maps=${SCRIPTS_DIRECTORY}'/maps.sh'
alias ct/=${SCRIPTS_DIRECTORY}'/current_time_area_google.sh'
alias check='bash -c "cd ~/PycharmProjects/github/playlist_check && venv/bin/python podcast/redbasset_podbean.py"'
alias anti=${SCRIPTS_DIRECTORY}'/antizapret.sh'
alias ip/=${SCRIPTS_DIRECTORY}'/my-ip-addr.sh'
alias c/=${SCRIPTS_DIRECTORY}'/cheat.sh'
alias usd=${SCRIPTS_DIRECTORY}'/usd-btc.sh'
alias usd/='curl -s https://raw.githubusercontent.com/extybr/daily-current-affairs/main/scripts/usd-btc.sh | bash -e'
alias tel/='telnet mapscii.me'
alias w/=${SCRIPTS_DIRECTORY}'/which-program.sh'
alias j/=${SCRIPTS_DIRECTORY}'/simple-parser-hh.sh'
alias jj/="$HOME${${SCRIPTS_DIRECTORY}#*~}/../../script-parser-HH-led/terminal/job.sh"
alias e/='exiftool $1'
alias s/='shc -r -f $1'
alias ts/=${SCRIPTS_DIRECTORY}'/timestamp.sh'
alias rgh/='cat ~/.zhistory | rg $1'
alias t/=${SCRIPTS_DIRECTORY}'/temperature_color_ptop.sh'
alias temp='watch -n 1 ${SCRIPTS_DIRECTORY}/temperature_ptop.sh'
alias ipa/=${SCRIPTS_DIRECTORY}'/dig_drill_ip.sh'
alias ti/=${SCRIPTS_DIRECTORY}'/trading-index.py'
alias cd/="pushd ${SCRIPTS_DIRECTORY}"
alias 90/='bash -c "cd ${SCRIPTS_DIRECTORY} && ./90s.sh"'
alias 40/='bash -c "source ${SCRIPTS_DIRECTORY}/set_get_volume.sh && ffplay http://prmstrm.1.fm:8000/top40 -nodisp"'
alias serv/=${SCRIPTS_DIRECTORY}'/local_server_forward_serveo.sh'
alias tg/=${SCRIPTS_DIRECTORY}'/tg_last_post.sh'
alias scr/=${SCRIPTS_DIRECTORY}'/script.sh'
alias lc/="mousepad $HOME${${SCRIPTS_DIRECTORY}#*~}/../man/linux_command.txt"
. $HOME/${${SCRIPTS_DIRECTORY}#*~}/ytdl.sh

function cy/ {
  current_dir=$(pwd)
  cd $HOME${${SCRIPTS_DIRECTORY}#*~}
  if [ "$#" -eq 1 ]; then
    ./country.sh "$1"
  else ./country.sh
  fi
  cd "${current_dir}" 
}

function fm {
  current_dir=$(pwd)
  cd $HOME${${SCRIPTS_DIRECTORY}#*~}
  ./fmedia.sh $*
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

alias py=python3.13
alias python=python3.13
alias python3=python3.13
alias pip=pip3.13
alias pip3=pip3.13
