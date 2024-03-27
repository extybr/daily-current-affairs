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
alias tux='cowsay -f tux LINUX Good !!!'
alias bsd='echo "\e[31m$(cowsay -f daemon HELP ME, PLEASE !!!)"'
alias dragon='echo "\e[35m$(cowsay -f dragon-and-cow Hello !)"'
alias wf='sudo ~/PycharmProjects/wifi_start.sh'
#alias chat='cd ~/PycharmProjects/temp/NeuroGPT; venv/bin/python webui_ru.py'
alias map='~/PycharmProjects/./map.sh'
alias check='~/PycharmProjects/./check.sh'
alias myssh='sudo ~/PycharmProjects/ssh_start.sh'
alias mpeg='~/PycharmProjects/mpeg.sh'
alias gitu='git add . && git commit -m'
alias fm='/home/tux/my_programs/fmedia-1/./fmedia'
alias anti='~/my_programs/./antizapret.sh'
alias ipp='~/my_programs/./my-ip-addr.sh'
alias ip='ip --color'
alias c/='~/my_programs/./cheat.sh'
alias tel='telnet mapscii.me'

# Disable autocorrect
# unsetopt correct_all
unsetopt correct

howto () {
	LYELLOW='\033[1;33m'; N='\033[0m'
  if [ $# -eq 0 ]
	then
	  echo -e "${LYELLOW} А что искать то?${N}"
  else
	curl cheat.sh/$1
  fi
}

btc () {
	LWHITE='\033[1;37m'; N='\033[0m'
  if [ $# -eq 0 ]
	then
	  curl rate.sx
  elif [ $# -eq 1 ]
	then
	  curl rate.sx/$1
  else
	echo -e "${LWHITE} Неправильный параметр${N}"
  fi
}

