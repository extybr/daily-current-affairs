#!/bin/bash
# $> ./ssh_host_choice.sh
# Выбор ssh-соединения

function sc {
  item=$(echo "$1" | fzf --prompt=" ssh   " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z "${item}" ]]; then
    echo "отмена"
    return 0
  else
    ssh "$(echo "${item}" | sed 's/..$//' | awk '{print $1}')"
  fi
}

host=$(grep 'Host '  ~/.ssh/config | awk '{print $2,$3}')
sc "${host}"
