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

alias reqrypt='~/my_programs/./reqrypt-1.3.1-linux64.sh'
alias sampler='sampler -c ~/my_programs/config.yml'
alias cm='cmatrix -r'
alias wr='~/my_programs/weather.sh'
alias slsl='~/my_programs/sl.sh'
alias os='~/my_programs/os.sh'
alias gpgd='gpg -d /run/media/tux/Samsung-1TB/mail.txt.gpg'
alias mocp='mocp -T /usr/share/moc/themes/darkdot_theme'
alias pspy='~/my_programs/./pspy64'
alias pac='sudo pacman -S'
alias pacs='~/my_programs/./pacs.sh'
# /usr/share/cows
alias tux='cowsay -f tux LINUX - Good !!!'
alias bsd='echo "\e[31m$(cowsay -f daemon Отдавай все свои биткоины !!!)"'
alias dragon='echo "\e[35m$(cowsay -f dragon-and-cow Тебя поджарить\?)"'
alias wf='sudo ~/PycharmProjects/wifi_start.sh'
#alias chat='cd ~/PycharmProjects/temp/NeuroGPT; venv/bin/python webui_ru.py'
alias map='~/PycharmProjects/./map.sh'
alias check='~/PycharmProjects/./check.sh'
alias myssh='sudo ~/PycharmProjects/ssh_start.sh'
alias mpeg='~/PycharmProjects/mpeg.sh'
alias gitu='git add . && git commit -m'
alias fm='/home/tux/my_programs/fmedia-1/./fmedia'
alias anti='~/my_programs/./antizapret.sh'
alias ip/='~/my_programs/./my-ip-addr.sh'
alias ip='ip --color'
alias c/='~/my_programs/./cheat.sh'
alias usd='~/my_programs/./usd-btc.sh'
alias usd/='curl -s https://raw.githubusercontent.com/extybr/daily-current-affairs/main/scripts/usd-btc.sh | bash -e'
alias tel='telnet mapscii.me'
alias w/='~/my_programs/./which-program.sh'
alias j/='~/my_programs/./simple-parser-hh.sh'

# Disable autocorrect
# unsetopt correct_all
unsetopt correct

btc () {
	LWHITE='\033[1;37m'; N='\033[0m'
  if [ $# -eq 0 ]
	then
	  curl rate.sx
  elif [ $# -eq 1 ]
	then
	  curl rate.sx/$1
  else
	echo -e "${LWHITE} Ожидалось не более 1 параметра${N}"
  fi
}

