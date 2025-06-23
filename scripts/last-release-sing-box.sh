#!/bin/bash -
# $> ./last-release-sing-box.sh
# Скачиваем последний релиз sing-box (+создаем дефолтный config)

set +H

# Сохраняем текущую директорию с гарантией возврата
current_dir=$(pwd)
trap 'cd "${current_dir}"' EXIT

# Переходим в рабочую директорию
mkdir -p "$HOME/my_programs/sing-box"
cd "$HOME/my_programs/sing-box" || {
    echo "❌ Ошибка перехода в $HOME/my_programs/sing-box"
    exit 1
}

# Основной код скрипта
echo "🔍 Проверяем последний релиз sing-box..."
RELEASES_PAGE=$(curl -s "https://github.com/SagerNet/sing-box/releases")
LATEST_RELEASE=$(echo "$RELEASES_PAGE" | grep -oP 'href="/SagerNet/sing-box/releases/tag/\K[^"]+' | head -n 1)

if [ -z "$LATEST_RELEASE" ]; then
    echo "❌ Ошибка: не удалось найти последний релиз\!"
    exit 1
fi

echo "✅ Найден релиз: $LATEST_RELEASE"

FILE_VERSION="${LATEST_RELEASE#v}"
DOWNLOAD_URL="https://github.com/SagerNet/sing-box/releases/download/${LATEST_RELEASE}/sing-box-${FILE_VERSION}-linux-amd64.tar.gz"
ARCHIVE_NAME="sing-box-${FILE_VERSION}-linux-amd64.tar.gz"
EXTRACTED_DIR="sing-box-${FILE_VERSION}-linux-amd64"

echo "⬇️ Скачиваем ($FILE_VERSION)..."
wget --show-progress -q "$DOWNLOAD_URL" || {
    echo "❌ Ошибка загрузки!"
    exit 1
}

echo "📦 Распаковываем..."
tar -xzf "$ARCHIVE_NAME" "$EXTRACTED_DIR/sing-box" || {
    echo "❌ Ошибка распаковки!"
    exit 1
}

echo "🔄 Переносим бинарник..."
mv "$EXTRACTED_DIR/sing-box" ./ || {
    echo "❌ Ошибка переноса!"
    exit 1
}

echo "🧹 Очищаем временные файлы..."
rm -rf "$ARCHIVE_NAME" "$EXTRACTED_DIR" || {
    echo "⚠️ Не удалось удалить временные файлы (но бинарник установлен)"
}

echo -e "\n✔️ Успешно! Исполняемый файл: $PWD/sing-box\n"

if ! [[ -f './run' ]]; then
  echo '#!/bin/bash
cd "$HOME/my_programs/sing-box"
./sing-box run -c sing-box-config.json' > 'run'
  chmod u+x run
fi

if ! [[ -f 'sing-box-config.json' ]]; then
  echo '{
  "log": {
    "level": "info"
  },
  "inbounds": [
    {
      "type": "socks",
      "tag": "socks-in",
      "listen": "127.0.0.1",
      "listen_port": 10808,
      "sniff": true
    },
    {
      "type": "http",
      "tag": "http-in",
      "listen": "127.0.0.1",
      "listen_port": 10809,
      "sniff": true
    }
  ],
  "outbounds": [
    {
      "type": "vless",
      "tag": "reality-out",
      "server": "XXXXXXXXXX",
      "server_port": 443,
      "uuid": "XXXXXXXXXX",
      "flow": "xtls-rprx-vision",
      "tls": {
        "enabled": true,
        "server_name": "XXXXXXXXXX",
        "utls": {
          "enabled": true,
          "fingerprint": "chrome"
        },
        "reality": {
          "enabled": true,
          "public_key": "XXXXXXXXXX",
          "short_id": "XXXXXXXXXX"
        }
      }
    }
  ]
}
' > sing-box-config.json
fi

