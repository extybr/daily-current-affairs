#!/bin/bash
# $> ./tg_last_post.sh igromania
# Последний пост с телеграм канала

white="\033[37m"
yellow="\e[33m"
blue="\e[36m"
violet="\e[35m"
normal="\033[0m"

if ! [ "$#" -eq 1 ]; then
  read -rp "$(tput bold)Channel: $(tput sgr0)" name
else name="$1"
fi

tg_channel=${name#*"https://t.me/"}
tg_channel=${name#*"t.me/"}

proxy=''
source "${SCRIPTS_DIRECTORY/'~'/$HOME}"/proxy.sh 1> /dev/null

html_content_page=$(curl -s ${proxy} "https://t.me/s/${tg_channel}/" | \
  grep  '<span class="tgme_widget_message_views">')
IFS=$'\n'
for url in $(echo "${html_content_page}")
do 
  last_post=$(echo "${url}")
done

url=$(echo "${last_post}" | grep -oP 'href="[^>]+><' | sed 's/href="//g ; s/"><//g')
if ! [ "${url}" ]
  then echo -e "${white}*** FAIL ***${normal}"
  exit 0
fi
echo -e "Ссылка на последний пост: ${blue}${url}${normal}"
datetime=$(echo "${last_post}" | grep -oP 'datetime="[^>]+00:00' | \
  sed 's/datetime="//g ; s/T/ /g ; s/+00:00//g')
echo -e "Дата поста: ${yellow}${datetime}${normal}"

html_last_post=$(curl -s "${url}")
before='<meta property="og:description" content="'
after='<meta property="twitter:title"'
text_after=${html_last_post%"$after"*}
text_before=${text_after#*"$before"}
post=$(echo "${text_before}" | sed 's/">//g')
echo -e "Пост:\n${violet}${post}${normal}"

