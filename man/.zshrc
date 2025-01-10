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
alias wf/="bash -c 'cd ~/PycharmProjects/github/wifi && sudo ./start.sh'"
alias myssh="bash -c 'cd ~/PycharmProjects/github/remote_control && sudo ./start.sh'"
alias mpeg='bash -c "cd ~/PycharmProjects/github/ffmpeg_gui && ./start_linux.sh"'
alias map=${SCRIPTS_DIRECTORY}'/map.sh'
alias maps=${SCRIPTS_DIRECTORY}'/maps.sh'
alias ct/=${SCRIPTS_DIRECTORY}'/current_time_area_google.sh'
alias check='bash -c "cd ~/PycharmProjects/github/playlist_check && venv/bin/python podcast/redbasset_podbean.py"'
alias anti=${SCRIPTS_DIRECTORY}'/antizapret.sh'
alias ip/=${SCRIPTS_DIRECTORY}'/my-ip-addr.sh'
alias c/=${SCRIPTS_DIRECTORY}'/cheat-command.sh'
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
alias fm="${SCRIPTS_DIRECTORY}/fmedia.sh"
alias 90/='bash -c "cd ${SCRIPTS_DIRECTORY} && ./90s.sh"'
alias 40/='bash -c "source ${SCRIPTS_DIRECTORY}/set_get_volume.sh && ffplay http://prmstrm.1.fm:8000/top40 -nodisp"'
alias serv/=${SCRIPTS_DIRECTORY}'/local_server_forward_serveo.sh'
alias tg/=${SCRIPTS_DIRECTORY}'/tg_last_post.sh'
alias scr/=${SCRIPTS_DIRECTORY}'/script.sh'
alias lc/="mousepad $HOME${${SCRIPTS_DIRECTORY}#*~}/../man/linux_command.txt"
source $HOME/${${SCRIPTS_DIRECTORY}#*~}/functions.sh

alias py=python3.13
alias python=python3.13
alias python3=python3.13
alias pip=pip3.13
alias pip3=pip3.13
