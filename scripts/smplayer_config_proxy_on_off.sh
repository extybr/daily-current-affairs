#!/bin/bash
# $> ./smplayer_config_proxy_on_off.sh
# включение/выключение прокси smplayer

smplayer_config="$HOME/.config/smplayer/smplayer.ini"
use_proxy=$(grep 'use_proxy=' "$smplayer_config")
echo -e "На текущий момент: \033[36m${use_proxy%=*}=\033[1;31m${use_proxy#*=}\033[0m"
use_proxy_revers="use_proxy=$( [ \"$use_proxy\" = \"use_proxy=true\" ] && echo false || echo true )"
sed -i "s/$use_proxy/$use_proxy_revers/" "$smplayer_config" \
&& echo -e "Замена на \033[36m${use_proxy_revers%=*}=\033[1;31m${use_proxy_revers#*=}\033[0m"

# для явного изменения результата (не используется)
obvious_change() {
  if [[ "$#" -eq 1 ]]; then
    if [[ "$1" == 't' ]] && [[ "$use_proxy" == 'use_proxy=false' ]]; then
      sed -i "s/$use_proxy/use_proxy=true/" "$smplayer_config" && echo -e "Замена на \033[036mtrue"
    elif [[ "$1" == 'f' ]] && [[ "$use_proxy" == 'use_proxy=true' ]]; then
      sed -i "s/$use_proxy/use_proxy=false/" "$smplayer_config" && echo -e "Замена на \033[036mfalse"
    fi
  fi
}
