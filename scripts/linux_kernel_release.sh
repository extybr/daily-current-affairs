#!/bin/bash
# $> ./linux_kernel_release.sh
# Linux Kernel / www.kernel.org / Релизы ядра линукс

echo -e "Protocol 	 Location
HTTP 	         \e[36mhttps://www.kernel.org/pub\e[0m
GIT 	         \e[36mhttps://git.kernel.org\e[0m
GIT_torvalds 	 \e[36mhttps://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/refs\e[0m
RSYNC 	         \e[36mrsync://rsync.kernel.org/pub\e[0m
GITHUB 	         \e[36mhttps://github.com/torvalds/linux/tags\e[0m\n"

curl -s https://www.kernel.org/releases.json \
| jq -r '.releases.[] | "name: " + .moniker, "tag: " + .version, "date: " + .released.isodate + "\n"'

