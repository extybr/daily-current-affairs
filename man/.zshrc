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
export SAMSUNG_DIRECTORY='/run/media/tux/Samsung-1TB'
export PLAYLIST_DIRECTORY="${SAMSUNG_DIRECTORY}/Desktop/Radio"
alias ip='ip --color'
alias gitu='git add . && git commit -m'
alias fm=${SCRIPTS_DIRECTORY}'/fmedia.sh'
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
alias myssh="${SCRIPTS_DIRECTORY}/ssh_start.sh"
alias mpeg=${SCRIPTS_DIRECTORY}'/mpeg.sh'
alias map=${SCRIPTS_DIRECTORY}'/map.sh'
alias maps=${SCRIPTS_DIRECTORY}'/maps.sh'
alias ct/=${SCRIPTS_DIRECTORY}'/current_time_area_google.sh'
alias check=${SCRIPTS_DIRECTORY}'/check.sh'
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
alias cre/=${SCRIPTS_DIRECTORY}'/curl_re.sh'
alias csh/=${SCRIPTS_DIRECTORY}'/rss_sh.sh'
alias ipa/=${SCRIPTS_DIRECTORY}'/dig_drill_ip.sh'
alias ri/=${SCRIPTS_DIRECTORY}'/rutor+search+magnet.sh'
alias ro/=${SCRIPTS_DIRECTORY}'/rutracker.sh'
alias nt/=${SCRIPTS_DIRECTORY}'/nnmclub.sh'
alias sc/=${SCRIPTS_DIRECTORY}'/scarabey.sh'
alias 13/=${SCRIPTS_DIRECTORY}'/1337x.sh'
alias bt/=${SCRIPTS_DIRECTORY}'/bitsearch.sh'
alias ti/=${SCRIPTS_DIRECTORY}'/trading-index.py'
alias cd/="pushd ${SCRIPTS_DIRECTORY}"
alias 90/=${SCRIPTS_DIRECTORY}'/90s.sh'
alias 40/=${SCRIPTS_DIRECTORY}'/top40.sh'
alias cy/=${SCRIPTS_DIRECTORY}'/country.sh'
alias serv/=${SCRIPTS_DIRECTORY}'/local_server_forward_serveo.sh'
alias tg/=${SCRIPTS_DIRECTORY}'/tg_last_post.sh'
alias scr/=${SCRIPTS_DIRECTORY}'/script.sh'
alias lc/="mousepad $HOME${${SCRIPTS_DIRECTORY}#*~}/../man/linux_command.txt"
. $HOME/${${SCRIPTS_DIRECTORY}#*~}/ratesx.sh

temp () {
watch -n 1 ${SCRIPTS_DIRECTORY}/temperature_ptop.sh
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

alias py=python3.13
alias python=python3.13
alias python3=python3.13
alias pip=pip3.13
alias pip3=pip3.13
