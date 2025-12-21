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

CURRENT_VERSION=$(./sing-box version | head -n 1 | cut -d ' ' -f3 2> /dev/null)
FILE_VERSION="${LATEST_RELEASE#v}"
DOWNLOAD_URL="https://github.com/SagerNet/sing-box/releases/download/${LATEST_RELEASE}/sing-box-${FILE_VERSION}-linux-amd64.tar.gz"
ARCHIVE_NAME="sing-box-${FILE_VERSION}-linux-amd64.tar.gz"
EXTRACTED_DIR="sing-box-${FILE_VERSION}-linux-amd64"

compare_versions() {
    echo "$1 $2" | awk '{
        split($1, a, /[.-]/);
        split($2, b, /[.-]/);
        
        for (i=1; i<=4; i++) {
            if (a[i] < b[i]) { print $2; exit; }
            if (a[i] > b[i]) { print $1; exit; }
        }
        
        # Compare pre-release tags
        if (a[5] != "" || b[5] != "") {
            if (a[5] == "" && b[5] != "") { print $1; exit; }
            if (a[5] != "" && b[5] == "") { print $2; exit; }
            if (a[5] < b[5]) { print $2; exit; }
            if (a[5] > b[5]) { print $1; exit; }
            
            if (a[6]+0 < b[6]+0) { print $2; exit; }
            if (a[6]+0 > b[6]+0) { print $1; exit; }
        }
        
        print $1;
    }'
}

newer=$(compare_versions "${CURRENT_VERSION}" "${LATEST_RELEASE#v}")

if [ "$newer" = "${CURRENT_VERSION}" ]; then
  echo "Текущая версия "${CURRENT_VERSION}" - это последний релиз"
  exit
fi

if [ -f "./sing-box" ]; then
  mv "./sing-box" "${CURRENT_VERSION}"
fi

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

