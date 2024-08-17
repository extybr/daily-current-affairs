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
alias ip='ip --color'
alias gitu='git add . && git commit -m'
alias fm=${SCRIPTS_DIRECTORY}'/fmedia.sh'
alias reqrypt=${SCRIPTS_DIRECTORY}'/./reqrypt-1.3.1-linux64.sh'
alias sampler='sampler -c ~/my_programs/config.yml'
alias pspy='~/my_programs/./pspy64'
alias cm='cmatrix -r'
alias mocp='mocp -T /usr/share/moc/themes/darkdot_theme'
alias gpgd='gpg -d /run/media/tux/Samsung-1TB/mail.txt.gpg'
alias gpgd/='gpgd | rg -A10 -B5 $1'
alias wr=${SCRIPTS_DIRECTORY}'/weather.sh'
alias slsl=${SCRIPTS_DIRECTORY}'/sl.sh'
alias os=${SCRIPTS_DIRECTORY}'/os.sh'
alias pac='sudo pacman -S'
alias pacs=${SCRIPTS_DIRECTORY}'/pacs.sh'
# /usr/share/cows
alias tux='cowsay -f tux LINUX - Good !!!'
alias bsd='echo "\e[31m$(cowsay -f daemon Отдавай все свои биткоины !!!)"'
alias dragon='echo "\e[35m$(cowsay -f dragon-and-cow Тебя поджарить\?)"'
alias wf="sudo ${SCRIPTS_DIRECTORY}/wifi_start.sh"
alias myssh="sudo ${SCRIPTS_DIRECTORY}/ssh_start.sh"
alias mpeg=${SCRIPTS_DIRECTORY}'/mpeg.sh'
alias map=${SCRIPTS_DIRECTORY}'/map.sh'
alias check=${SCRIPTS_DIRECTORY}'/check.sh'
alias anti=${SCRIPTS_DIRECTORY}'/antizapret.sh'
alias ip/=${SCRIPTS_DIRECTORY}'/my-ip-addr.sh'
alias c/=${SCRIPTS_DIRECTORY}'/cheat.sh'
alias usd=${SCRIPTS_DIRECTORY}'/usd-btc.sh'
alias usd/='curl -s https://raw.githubusercontent.com/extybr/daily-current-affairs/main/scripts/usd-btc.sh | bash -e'
alias tel='telnet mapscii.me'
alias w/=${SCRIPTS_DIRECTORY}'/which-program.sh'
alias j/=${SCRIPTS_DIRECTORY}'/simple-parser-hh.sh'
alias jj/='~/PycharmProjects/github/script-parser-HH-led/terminal/job.sh'
# https://github.com/yt-dlp/yt-dlp#readme
alias y/="~/bin/yt-dlp -S 'res:720,fps' $1"
alias e/='exiftool $1'
alias s/='shc -r -f $1'
alias rgh/='cat ~/.zhistory | rg $1'
alias t/=${SCRIPTS_DIRECTORY}'/temperature_color_ptop.sh'
alias cre/=${SCRIPTS_DIRECTORY}'/curl_re.sh'
alias csh/=${SCRIPTS_DIRECTORY}'/rss_sh.sh'
alias ipa/=${SCRIPTS_DIRECTORY}'/dig_drill_ip.sh'
alias ru/=${SCRIPTS_DIRECTORY}'/rutor.sh'
alias cd/='pushd '${SCRIPTS_DIRECTORY}
alias 90/=${SCRIPTS_DIRECTORY}'/90s.sh'
alias cy/=${SCRIPTS_DIRECTORY}'/country.sh'
. $HOME/${${SCRIPTS_DIRECTORY}#*~}/ratesx.sh

temp () {
watch -n 1 ${SCRIPTS_DIRECTORY}/temperature_ptop.sh
}
