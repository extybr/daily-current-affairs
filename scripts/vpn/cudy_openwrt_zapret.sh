#!/bin/bash
# openwrt с комплексом antidpi для Cudy TR3000 / напоминалка

echo -e "
Hostname          \e[36mOpenWrt\e[0m
Model             \e[36mCudy TR3000 256MB v1\e[0m
Architecture      \e[36mARMv8 Processor rev 4\e[0m
Target Platform   \e[36mmediatek/filogic\e[0m
"

##################################################
# $> cat /etc/*-release
# NAME="OpenWrt"
# VERSION="25.12.5"
# ID="openwrt"
# ID_LIKE="lede openwrt"
# PRETTY_NAME="OpenWrt 25.12.5"
# VERSION_ID="25.12.5"
# HOME_URL="https://openwrt.org/"
# FIRMWARE_URL="https://downloads.openwrt.org/"
# BUILD_ID="r33051-f5dae5ece4"
# OPENWRT_BOARD="mediatek/filogic"
# OPENWRT_ARCH="aarch64_cortex-a53"
##################################################

##### Общая информация для поиска прошивки openwrt для cudy
# https://firmware-selector.openwrt.org - где искать,
# Cudy TR3000 256mb v1 - что искать
#
# https://downloads.openwrt.org/releases/$tag/targets/mediatek/filogic - где искать, 
# cudy_tr3000-256mb-v1-squashfs-sysupgrade.bin или cudy_tr3000-256mb-v1-initramfs-kernel.bin - что искать
#
# https://www.cudy.com/ru-by/pages/download-center/tr3000-256mb-1-0 - где искать / официальный сайт для заводской прошивки
# TR3000-256MB 1.0 - что искать

snapshots_mediatek='https://downloads.openwrt.org/snapshots/targets/mediatek/filogic'
# initramfs_kernel="$snapshots_mediatek/openwrt-mediatek-filogic-cudy_tr3000-256mb-v1-initramfs-kernel.bin"
squashfs_sysupgrade="$snapshots_mediatek/openwrt-mediatek-filogic-cudy_tr3000-256mb-v1-squashfs-sysupgrade.bin"

# определяем последний релиз openwrt для Cudy
tag=$(curl -s 'https://downloads.openwrt.org' \
      | grep '>Stable Release<' -A 10 \
      | grep 'href="releases/' \
      | grep -oP 'releases/\K[^"]+' \
      | awk -F/ '{print $1}')

# https://firmware-selector.openwrt.org/?version=$tag&target=mediatek%2Ffilogic&id=cudy_tr3000-256mb-v1  # страница поиска openwrt для cudy
# скачиваем образ openwrt для cudy (последний релиз)
wget "https://downloads.openwrt.org/releases/$tag/targets/mediatek/filogic/openwrt-$tag-mediatek-filogic-cudy_tr3000-256mb-v1-squashfs-sysupgrade.bin"
# wget "$squashfs_sysupgrade"  # или так: скачиваем образ openwrt для cudy

##### Записать openwrt на cudy
# https://4pda.to/forum/index.php?showtopic=1099628&st=1080#entry137770774  # информация
#
# 1. Качаем переходную прошивку: DTS_and_intermediate_firmware.zip (9.66 МБ) -
#    https://4pda.to/forum/dl/post/33444032/DTS_and_intermediate_firmware.zip
# 2. Распаковываем архив и получаем cudy_tr3000-v1-sysupgrade.bin
# 3. Заходим в админку роутера через браузер на 192.168.10.1, стандартный пароль admin.
#    В Upgrade Firmware прошиваем cudy_tr3000-v1-sysupgrade.bin. Ждём пару минут.
# 5. Качаем на сайте OpenWRT файл прошивки openwrt-$tag-mediatek-filogic-cudy_tr3000-256mb-v1-squashfs-sysupgrade.bin
#    для Cudy TR3000 256mb
# 7. В админке System -> Flash Firmware, загружаем файл. Ждём пару минут.
#    Прошивка с сайта OpenWRT - без включенного WiFi !!!

# неофициальные сборки
# https://github.com/weekdaycare/immortalwrt-mt7981-cudy-tr3000/releases

ssh root@192.168.2.1  # подключаемся к cudy по ssh
# https://github.com/StressOzz/Zapret-Manager
# скачиваем и устанавливаем Zapret-Manager по ssh на openwrt-cudy
# sh <(wget -O - https://raw.githubusercontent.com/StressOzz/Zapret-Manager/main/Zapret-Manager.sh)
# zms  # запускаем Zapret-Manager на cudy для настройки и выбора стратегий

# отдельно, установка podkop по ssh на cudy
# https://github.com/itdoginfo/podkop
# sh <(wget -O - https://raw.githubusercontent.com/itdoginfo/podkop/refs/heads/main/install.sh)
# или
# отдельно, установка forkop по ssh на cudy
# https://github.com/ushan0v/forkop
# sh <(wget -O - https://raw.githubusercontent.com/ushan0v/forkop/main/install.sh)
# или
# fix sing-box: https://github.com/moix89/podkop-xhttp-patch / установка sing-box-extended, патч для XHTTP, проверка podkop и sing-box
# 1. wget -O /tmp/sb-ext.sh https://raw.githubusercontent.com/EikeiDev/OpenWRT-sing-box-extended/refs/heads/main/install.sh && sh /tmp/sb-ext.sh
# 2. wget -O /tmp/patch.sh https://raw.githubusercontent.com/moix89/podkop-xhttp-patch/main/install.sh && sh /tmp/patch.sh
# 3. podkop global_check && sing-box check -c /etc/sing-box/config.json

