#!/bin/bash
# openwrt releases

URL="openwrt.org"
DOWNLOADS="https://downloads.$URL"
VERSION=$(curl -s "${DOWNLOADS}/.versions.json" | jq -r '.stable_version')
TARGETS="bcm27xx/bcm2710"
MODEL="rpi-3"

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
  echo -e "$firmware_link\n"
  dtarget=$(echo "${TARGETS}" | sed 's/\//-/')
  declare -a img=(ext4-factory squashfs-factory ext4-sysupgrade squashfs-sysupgrade)
  curl -O "${DOWNLOADS}/releases/${VERSION}/targets/${TARGETS}/openwrt-${VERSION}-${dtarget}-${MODEL}-${img[1]}.img.gz" &>/dev/null && \
  echo -e "Скачан образ: ${img[1]}.img.gz\n"
}

json() {
  curl -s "${DOWNLOADS}/releases/${VERSION}/.overview.json" | jq -r ".profiles.[] | select(.id == \"${MODEL}\")"
  echo
  curl -s "${DOWNLOADS}/snapshots/targets/${TARGETS}/profiles.json" | jq -r '. | .arch_packages,.target,.version_number,.linux_kernel.version'
}

echo "Stable version = $VERSION"
echo "Stable release = $(stable)"
echo -e "\ngithub = $(github)\n"
# releases
firmware
json

