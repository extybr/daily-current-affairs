#!/bin/bash
# $> ./smplayer_youtube.sh https://youtu.be/3i1QzPPCNzk
# Запуск smplayer с прямой ссылкой youtube (не лучшее качество)

# проверяем есть ли валидная ссылка
if [[ "$#" -ne 1 ]] || ! [[ "$1" =~ ^("https://www.youtube.com/"|"https://youtube.com/"|"https://youtu.be") ]]; then
  echo -e "*** \033[31mОжидалась ссылка на youtube-видео\033[0m ***" && exit
fi

# получаем id-видео
url=$(echo "$1" | sed 's/https:\/\/// ; s/www\.// ; s/youtube\.com\/// ; s/youtu\.be\/// ; s/watch?v=//')

# получаем прямую ссылку
getUrl() {
  curl "https://www.youtube.com/youtubei/v1/player" \
  --silent \
  --request POST \
  --json "{'videoId':\"$url\",'context':{'client':{'clientName':'ANDROID','clientVersion':'21.02.35','androidSdkVersion':30,'userAgent':'com.google.android.youtube/21.02.35(Linux;U;Android11)gzip','osName':'Android','osVersion':'11'}}}" \
  | jq -r ".streamingData.formats.[0].url"
}

# запускаем плеер с полученной прямой ссылкой
nohup smplayer $(getUrl) 2>/dev/null &>/dev/null &

# убиваем (с задержкой) терминальную сессию, которая запустила плеер
sleep 3 && pkill -1 -t $(echo $(ls -l $(tty)) | awk '{print $10}' | sed 's/\/dev\///') 

