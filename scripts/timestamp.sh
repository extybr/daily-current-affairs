#!/bin/sh

errors() {
echo -e "The data format is invalid.\nExample:"
echo "convert timestamp to date: '1725787421'"
echo "convert date to timestamp: 'm/d/y H:M:S'"
}

if [ "$#" -eq 0 ]
  then date +%s  # unix timestamp
elif [ "$#" -eq 1 ]
  then 
  if [ "$1" -gt 0 ] 2>/dev/null
    then ts=$(date --date="@$1" 2> /dev/null)
    if ! [[ "${ts}" ]]
      then errors
      else echo "${ts}"
    fi
  else dt=$(date -d "$1" +"%s" 2> /dev/null)
    if ! [[ "${dt}" ]]
      then errors
      else echo "${dt}"
    fi
  fi
else echo "ожидалось не более 1 параметра, а передано $#"
fi
