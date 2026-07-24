#!/bin/bash
# openwrt с комплексом antidpi для rpi-3 / напоминалка
# 1) Установка openwrt на rpi-3, запись образа на microSD, настройка openwrt на rpi-3
# 2) Подключение к rpi-3 по ssh, скачивание и установка Zapret-Manager на rpi-3, настройка и выбор стратегии
# 3) Установка дополнительных сервисов (при необходимости)
##################################################
# $> cat /etc/*-release
# NAME="OpenWrt"
# VERSION="25.12.0-rc5"
# ID="openwrt"
# ID_LIKE="lede openwrt"
# PRETTY_NAME="OpenWrt 25.12.0-rc5"
# VERSION_ID="25.12.0-rc5"
# HOME_URL="https://openwrt.org/"
# FIRMWARE_URL="https://downloads.openwrt.org/"
# BUILD_ID="r32673-482ba7230a"
# OPENWRT_BOARD="bcm27xx/bcm2710"
# OPENWRT_ARCH="aarch64_cortex-a53"
##################################################

snapshots_bcm2710='https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2710'
ext4_factory="$snapshots_bcm2710/openwrt-bcm27xx-bcm2710-rpi-3-ext4-factory.img.gz"
# ext4_sysupgrade="$snapshots_bcm2710/openwrt-bcm27xx-bcm2710-rpi-3-ext4-sysupgrade.img.gz"
# squashfs_factory="$snapshots_bcm2710/openwrt-bcm27xx-bcm2710-rpi-3-squashfs-factory.img.gz"
# squashfs_sysupgrade="$snapshots_bcm2710/openwrt-bcm27xx-bcm2710-rpi-3-squashfs-sysupgrade.img.gz"

# определяем последний релиз openwrt для rpi-3
tag=$(curl -s 'https://downloads.openwrt.org' \
      | grep '>Stable Release<' -A 10 \
      | grep 'href="releases/' \
      | grep -oP 'releases/\K[^"]+' \
      | awk -F/ '{print $1}')

# https://firmware-selector.openwrt.org/?version=$tag&target=bcm27xx%2Fbcm2710&id=rpi-3  # страница поиска openwrt для rpi-3
# скачиваем образ openwrt для rpi-3 (последний релиз)
wget "https://downloads.openwrt.org/releases/$tag/targets/bcm27xx/bcm2710/openwrt-$tag-bcm27xx-bcm2710-rpi-3-ext4-factory.img.gz"
# wget "$ext4_factory"  # или так: скачиваем образ openwrt для rpi-3

# записать openwrt-$tag-bcm27xx-bcm2710-rpi-3-ext4-factory.img на microSD
sudo "$HOME/my_programs/./RaspberryPiImager_2.0.0_amd64.AppImage"

ssh root@192.168.2.1  # подключаемся к RaspberryPi по ssh на openwrt-rpi-3
# https://github.com/StressOzz/Zapret-Manager
# скачиваем и устанавливаем Zapret-Manager по ssh на openwrt-rpi-3
# sh <(wget -O - https://raw.githubusercontent.com/StressOzz/Zapret-Manager/main/Zapret-Manager.sh)
# zms  # запускаем Zapret-Manager на rpi-3 для настройки и выбора стратегий

# отдельно, установка zapret по ssh на openwrt-rpi-3
# curl -fsSL https://raw.githubusercontent.com/remittor/zapret-openwrt/zap1/zapret/update-pkg.sh -o /tmp/zap.sh && sh /tmp/zap.sh -u 1
# отдельно, установка zapret2 по ssh на openwrt-rpi-3, после установки - перелогиниться
# curl -fsSL https://raw.githubusercontent.com/remittor/zapret-openwrt/zap1/zapret/update-pkg.sh -o /tmp/zap.sh && sh /tmp/zap.sh -u 2

# отдельно, установка podkop по ssh на openwrt-rpi-3
# https://github.com/itdoginfo/podkop
# sh <(wget -O - https://raw.githubusercontent.com/itdoginfo/podkop/refs/heads/main/install.sh)

# установка неподписанного пакета на примере установки youtubeUnblock
# wget https://github.com/Waujito/youtubeUnblock/releases/download/v1.3.1/youtubeUnblock-1.3.1-1-4a223b0-aarch64_cortex-a53-openwrt-25.12.apk
# apk add --allow-untrusted youtubeUnblock-1.3.1-1-4a223b0-aarch64_cortex-a53-openwrt-25.12.apk
# ответ системы:
# (1/1) Installing youtubeUnblock (1.3.1~4a223b0-r1)
#  Executing youtubeUnblock-1.3.1~4a223b0-r1.post-install
#  * cfg02d2da
#  * youtubeUnblock is running as: '/usr/bin/youtubeUnblock  --queue-num=537 --packet-mark=32768 --tls=enabled --sni-domains=googlevideo.com,ggpht.com,ytimg.com,youtube.com,play.google.com,youtu.be,googleapis.com,googleusercontent.com,gstatic.com,l.google.com, --fake-sni=0 --frag-sni-reverse=1 --frag-sni-faked=0 --frag-middle-sni=1 --synfake=0 --fake-sni-seq-len=1 --fake-sni-type=default --faking-strategy=pastseq --frag=tcp --frag-sni-pos=1 --fk-winsize=0 --seg2delay=0 --sni-detection=parse --udp-mode=fake --udp-fake-seq-len=6 --udp-fake-len=64 --udp-filter-quic=disabled --udp-faking-strategy=none  '
#  * [!] Automatically including '/usr/share/nftables.d/ruleset-post/537-youtubeUnblock.nft'
# OK: 73.0 MiB in 202 packages

