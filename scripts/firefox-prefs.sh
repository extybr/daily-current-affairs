#!/bin/bash
# Скрипт настройки Firefox для Linux
# Куда сохранять настройки: ~/.mozilla/firefox/*.default-release/prefs.js

set -e

echo "🦊 Настройка Firefox..."

# Находим профиль Firefox
PROFILE_DIR=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*.default*" | head -n 1)

if [ -z "$PROFILE_DIR" ]; then
    echo "❌ Профиль Firefox не найден! Запустите Firefox сначала."
    exit 1
fi

PREFS_FILE="$PROFILE_DIR/prefs.js"

# Создаем резервную копию
cp "$PREFS_FILE" "$PREFS_FILE.backup.$(date +%Y%m%d)"

# Добавляем настройки
{
    echo 'user_pref("browser.startup.page", 3);                       // Восстанавливать сессию'
    echo 'user_pref("browser.tabs.loadInBackground", true);           // Открывать вкладки в фоне'
    echo 'user_pref("browser.tabs.loadBookmarksInBackground", true);  // Фоновая загрузка закладок'
    echo 'user_pref("browser.ctrlTab.recentlyUsedOrder", false);      // Порядок вкладок по порядку'
    echo 'user_pref("privacy.trackingprotection.enabled", true);      // Защита от отслеживания'
    echo 'user_pref("privacy.resistFingerprinting", true);            // Защита от цифрового отпечатка'
    echo 'user_pref("toolkit.telemetry.enabled", false);              // Отключить телеметрию'
    # echo 'user_pref("network.http.referer.trimmingPolicy", 2);      // Безопасный Referer'
    echo 'user_pref("browser.search.suggest.enabled", false);         // Отключить подсказки поиска'
    echo 'user_pref("browser.urlbar.suggest.searches", false);        // Отключить поисковые подсказки'
    echo 'user_pref("browser.newtabpage.activity-stream.showSearch", false);  // Убрать поиск с новой вкладки'
    echo 'user_pref("browser.compactmode.show", true);                // Включить компактный режим'
    echo 'user_pref("browser.uidensity", 1);                          // Компактный интерфейс'
    echo 'user_pref("layers.acceleration.force-enabled", true);       // Аппаратное ускорение'
    echo 'user_pref("gfx.webrender.all", true);                       // Включить WebRender'
    echo 'user_pref("media.hardware-video-decoding.enabled", true);   // Аппаратное декодирование видео'
    echo 'user_pref("widget.non-native-theme.enabled", true);         // Нативные темы GTK'
    echo 'user_pref("privacy.firstparty.isolate", true);              // Защита от кросс-доменного трекинга'
    echo 'user_pref("privacy.purge_trackers.enabled", true);          // Автоочистка трекеров'
    echo 'user_pref("network.dns.disablePrefetch", false);            // DNS-prefetch для ускорения загрузки'
    echo 'user_pref("network.predictor.enabled", true);               // Предзагрузка страниц'
} >> "$PREFS_FILE"

echo "✅ Настройки применены к: $PREFS_FILE"
echo "🔄 Перезапустите Firefox для вступления изменений в силу"

