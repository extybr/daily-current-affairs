#!/bin/bash
# $> ./openwrt_release.sh rpi
# $> ./openwrt_release.sh c
# Проверяет релизы openwrt и скачивает прошивки для RaspberryPi-3B+ и Cudy-TR3000-256mb-v1

URL="openwrt.org"
DOWNLOADS="https://downloads.$URL"
VERSION=$(curl -s "${DOWNLOADS}/.versions.json" | jq -r '.stable_version')

case "$1" in
  r|rpi)
  TARGETS="bcm27xx/bcm2710"
  MODEL="rpi-3"
  IMG=(ext4-factory squashfs-factory ext4-sysupgrade squashfs-sysupgrade)
  EXT="img.gz"
  ;;
  c|cudy)
  TARGETS="mediatek/filogic"
  MODEL="cudy_tr3000-256mb-v1"
  IMG=(initramfs-kernel squashfs-sysupgrade)
  EXT="bin"
  ;;
  *) echo -e "Неверные параметры. Пример:\n  ./openwrt_release.sh r      # для RaspberryPi-3
  ./openwrt_release.sh cudy   # для Cudy-TR3000-256mb-v1" && exit
  ;;
esac  

stable() {
  curl -s "${DOWNLOADS}" | grep '>Stable Release<' -A 10 | grep -oP '>OpenWrt\K[^<]+'
}

github() {
  curl -s "https://api.github.com/repos/openwrt/openwrt/releases" | jq -r '.[0] | .tag_name, .published_at'
}

releases() {
  curl -s "${DOWNLOADS}/releases/"
  curl -s "${DOWNLOADS}/snapshots/targets/${TARGETS}"
}

firmware() {
  ftarget=$(echo "${TARGETS}" | sed 's/\//%2F/')
  firmware_link="https://firmware-selector.$URL/?version=${VERSION}&target=${ftarget}&id=${MODEL}"
  echo -e "\e[31m$firmware_link\e[0m\n"
  dtarget=$(echo "${TARGETS}" | sed 's/\//-/')
  curl -O "${DOWNLOADS}/releases/${VERSION}/targets/${TARGETS}/openwrt-${VERSION}-${dtarget}-${MODEL}-${IMG[1]}.${EXT}" &>/dev/null && \
  echo -e "Скачан образ: ${IMG[1]}.${EXT}\n"
}

json() {
  curl -s "${DOWNLOADS}/releases/${VERSION}/.overview.json" | jq -r ".profiles.[] | select(.id == \"$2\")"
  echo
  curl -s "${DOWNLOADS}/snapshots/targets/$1/profiles.json" | jq -r '. | "arch_packages: " + .arch_packages,"target: " + .target,"version_number: " + .version_number,"linux_kernel: " + .linux_kernel.version'
}

echo "Stable version = $VERSION"
echo "Stable release = $(stable)"
echo -n "Latest = " && curl -s "https://sysupgrade.$URL/json/v1/latest.json" | jq -r '.latest.[0]'
echo -e "\ngithub = $(github)\n"
# releases
firmware
json  "$TARGETS" "$MODEL"

