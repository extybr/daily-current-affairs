#!/bin/bash
# $> ./smplayer_youtube.sh https://youtu.be/3i1QzPPCNzk
# Запуск smplayer с прямой ссылкой youtube (не лучшее качество)

# проверка аргументов
if [[ $# -ne 1 ]]; then
  echo "❌ Укажите одну ссылку на YouTube"
  exit 1
fi

# извлечение ID видео
VIDEO_ID=$(echo "$1" | sed -E 's/.*(v=|be\/)([a-zA-Z0-9_-]{11}).*/\2/')
if [[ -z "$VIDEO_ID" ]]; then
  echo "❌ Не удалось извлечь ID видео из ссылки"
  exit 1
fi

# диагностика 
run_diagnostic() {
    echo -e "\033[35m🔍 Диагностика Google CDN\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    echo -e "\033[1;33m▶ IPv4:\033[0m"
    curl -4 -s -o /dev/null -w "  Статус: %{http_code}  (%{time_total}с)\n" \
        "https://redirector.googlevideo.com/report_mapping?di=no" 2>/dev/null
    
    echo -e "\033[1;33m▶ Текущий хост:\033[0m"
    curl -s "https://redirector.googlevideo.com/report_mapping?di=no" 2>/dev/null | \
        head -1 | awk '{print "  " $0}'
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# получение прямой ссылки
get_video_url() {
  local url=$(curl -s -X POST "https://www.youtube.com/youtubei/v1/player" \
    -H "Content-Type: application/json" \
    -d '{
      "videoId": "'"$VIDEO_ID"'",
      "context": {
        "client": {
          "clientName": "ANDROID",
          "clientVersion": "21.02.35",
          "androidSdkVersion": 30,
          "osName": "Android",
          "osVersion": "11"
        }
      }
    }' | jq -r '.streamingData.formats.[0].url')

  if [[ -z "$url" ]]; then
    echo "❌ Не удалось получить ссылку" >&2
    exit 1
  fi
  echo "$url"
}

run_diagnostic  # запускаем диагностику

VIDEO_URL=$(get_video_url)
echo -e "✍️  Прямая ссылка на хост: \033[35mhttps://$(echo "$VIDEO_URL" | awk -F/ '{print $3}')\033[0m"
echo "✅ Ссылка получена, запуск smplayer..."

# запуск плеера в фоне
smplayer "$VIDEO_URL" &>/dev/null & disown

echo -e "🎬 Плеер запущен (PID: \033[35m$!\033[0m)"
