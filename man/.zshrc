# Используем стандартный для Zsh файл истории
HISTFILE=~/.zhistory
HISTSIZE=20000
SAVEHIST=20000

# Настройки истории
setopt appendhistory           # Добавлять в историю, а не перезаписывать
setopt INC_APPEND_HISTORY      # Добавлять команды сразу, а не при выходе
setopt SHARE_HISTORY           # Делиться историей между сессиями
setopt HIST_IGNORE_DUPS        # Не сохранять повторяющиеся команды
setopt HIST_IGNORE_SPACE       # Не сохранять команды, начинающиеся с пробела
unsetopt correct               # Отключаем исправление команд
# unsetopt correctall          # Отключаем исправление аргументов команд
setopt extendedglob            # Расширенное шаблонирование (глоббинг). Включает мощные шаблоны для поиска файлов.
setopt autocd                  # Автоматический переход в каталог. Если ввести имя каталога без команды cd, Zsh автоматически перейдёт в него.
setopt nomatch                 # Не выдавать ошибку, если шаблон не совпал
unsetopt beep                  # Отключить звуковой сигнал (бип)
unsetopt notify                # Не уведомлять сразу о завершении фоновых задач

# Themes
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Fish-like syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# pkgfile "command not found" handler
source /usr/share/doc/pkgfile/command-not-found.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export wlan0='wlan0'
export wlan1='wlan1'
export TERMINAL="terminator"
export GITHUB_DIRECTORY="${HOME}/PycharmProjects/github"
export GITLAB_DIRECTORY="${HOME}/PycharmProjects/gitlab"
export SCRIPTS_DIRECTORY="${GITHUB_DIRECTORY}/daily-current-affairs/scripts"
export TRACKER_PARSER_DIRECTORY="${GITHUB_DIRECTORY}/tracker_parser"
export SAMSUNG_DIRECTORY="/run/media/${USER}/Samsung-1TB"
export PLAYLIST_DIRECTORY="${SAMSUNG_DIRECTORY}/Desktop/Radio"
alias cm/='cmatrix -r'
alias sl/=${SCRIPTS_DIRECTORY}'/sl.sh'
alias mo/="$HOME/my_programs/Momoisay/./momoisay -f"  # https://github.com/Mon4sm/momoisay
alias merry="$HOME/my_programs/tree-christmas.sh"
alias po/='ponysay "Hello, Linux" 2> /dev/null'  # https://github.com/erkin/ponysay
alias tux='cowsay -f tux LINUX - Good !!!'
alias bsd='echo "\e[31m$(cowsay -f daemon Отдавай все свои биткоины !!!)"'
alias dragon='echo "\e[35m$(cowsay -f dragon-and-cow Тебя поджарить\?)"'
alias mocp='mocp -T /usr/share/moc/themes/darkdot_theme'
alias ph="${SCRIPTS_DIRECTORY}/phiola.sh"
alias 40/="ph http://prmstrm.1.fm:8000/top40"
alias 90/='ffplay "https://regiocast.streamabc.net/regc-90s90spop4760822-mp3-192-9403761" -nodisp -volume 3; clear'
alias e+='ffplay http://ep256.hostingradio.ru:8052/europaplus256.mp3 -nodisp -volume 3'
alias gpgd='gpg2 -d ${SAMSUNG_DIRECTORY}/mail.txt.gpg'
alias gpgd/='gpgd | rg -A10 -B5 $1'
alias pac='sudo pacman -S'
alias pacs=${SCRIPTS_DIRECTORY}'/pacs.sh'
alias gm/='gnome-maps -S'
alias map=${SCRIPTS_DIRECTORY}'/map.sh'
alias maps=${SCRIPTS_DIRECTORY}'/maps.sh'
alias wf/='bash -c "cd ${GITHUB_DIRECTORY}/wifi && sudo ./start.sh"'
alias myssh='bash -c "cd ${GITHUB_DIRECTORY}/remote_control && sudo ./start.sh"'
alias mpeg='bash -c "cd ${GITHUB_DIRECTORY}/ffmpeg_gui && ./start_linux.sh"'
alias check='bash -c "cd ${GITHUB_DIRECTORY}/playlist_check && uv run podcast/redbasset_podbean.py"'
alias j/=${SCRIPTS_DIRECTORY}'/simple-parser-hh.sh'
alias jj/="${GITHUB_DIRECTORY}/script-parser-HH-led/terminal/job.sh"
alias w/=${SCRIPTS_DIRECTORY}'/which-program.sh'
alias rgh/='cat ~/.zhistory | rg $1'
alias t/=${SCRIPTS_DIRECTORY}'/temperature_color_ptop.sh'
alias temp='watch -n 1 ${SCRIPTS_DIRECTORY}/temperature_ptop.sh'
alias ipa/=${SCRIPTS_DIRECTORY}'/dig_drill_ip.sh'
alias ti/=${GITLAB_DIRECTORY}'/tradingindex_to_html_sql_csv_json/trading-index.py'
alias ts/=${SCRIPTS_DIRECTORY}'/timestamp.sh'
alias ct/=${SCRIPTS_DIRECTORY}'/current_time_area_google.sh'
alias anti=${SCRIPTS_DIRECTORY}'/antizapret.sh'
alias ip/=${SCRIPTS_DIRECTORY}'/my-ip-addr.sh'
alias c/=${SCRIPTS_DIRECTORY}'/cheat-command.sh'
alias tg/=${SCRIPTS_DIRECTORY}'/tg_last_post.sh'
alias wr/=${SCRIPTS_DIRECTORY}'/weather.sh'
alias os/=${SCRIPTS_DIRECTORY}'/os.sh'
alias scr/=${SCRIPTS_DIRECTORY}'/script.sh'
alias usd=${SCRIPTS_DIRECTORY}'/usd-btc.sh'
alias usd/='curl -s https://raw.githubusercontent.com/extybr/daily-current-affairs/main/scripts/usd-btc.sh | bash -e'
alias serv/=${SCRIPTS_DIRECTORY}'/local_server_forward_serveo.sh'
alias tel/='telnet mapscii.me'
alias cd/="pushd ${SCRIPTS_DIRECTORY}"
alias lc/="mousepad ${SCRIPTS_DIRECTORY}/../man/linux_command.txt"
# alias sampler='sampler -c ~/my_programs/config.yml'
alias pspy='~/my_programs/./pspy64'
alias e/='exiftool $1'
alias s/='shc -r -f $1'
alias el/='expr length'
alias ls='ls --color=auto'
alias ip='ip --color'
alias grep='grep --color=auto'
alias py=python3.13

source ${SCRIPTS_DIRECTORY}/functions.sh

# Переконфигурирование zsh (все остальные строки перед этим удалить или закомментировать)
# source /usr/share/cachyos-zsh-config/cachyos-config.zsh
