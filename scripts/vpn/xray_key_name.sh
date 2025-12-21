#!/bin/bash
# $> ./xray_key_name.sh
# Название (кличка) xray vpn ключа

vless_key="$HOME/my_programs/xray/vless.key"
source "${vless_key}"
short_id=$(echo "${vpn_key}" | grep -oP '&sid=[^>]+#' | sed 's/&sid=//g ; s/#//g')
key_name=$(echo "${vpn_key}" | grep -oP "${short_id}[^>]+" | sed "s/${short_id}#//g")

