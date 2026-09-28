#!/bin/zsh

function x/ {
  if (( "$#" > 0 )) && [ "$1" = 'k' ]; then
    # "${SCRIPTS_DIRECTORY}/vpn/xray_key_change.sh"
    echo '*** изменение ключей отключено ***'
  elif (( "$#" == 1 )) && [[ "$1" =~ ^(vless://) ]]; then
    "${SCRIPTS_DIRECTORY}/vpn/xray_config_fix.sh" "$1"
    "${SCRIPTS_DIRECTORY}/vpn/xray-service-fix.sh"
  else
    source "${SCRIPTS_DIRECTORY}/vpn/xray_key_name.sh"
    echo -n "xray: "
    python "${SCRIPTS_DIRECTORY}/url_coder.py" decoder "${key_name}"
    prefix="%16%03%01%00%C2%A8%01%01#"
    source "$HOME/my_programs/outline-sdk/outline.key"
    o_key_name=$(echo "${outline_key}" | \
                 grep -oP "${prefix}[^>]+" | \
                 sed "s/${prefix}//")
    echo -n "outline: "
    python "${SCRIPTS_DIRECTORY}/url_coder.py" decoder "${o_key_name}"
  fi
}

