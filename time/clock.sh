#!/bin/bash
# $ ./clock.sh
# Time in console

watch_time() {
  # вариант с watch
  exec watch -tn 1 date '+%l:%M:%S%p'
}

show_time() {
    while true; do
        tput cup 2 50  # Перемещаем курсор
        echo -e "\e[1m\e[5m\e[31m$(date +"%H:%M:%S")\e[0m"
        
        tput cup 3 50
        echo -e "\e[32m$(date +"%d.%m.%Y")\e[0m"
        
        tput cup 4 50
        echo -e "\e[90mCtrl+C to exit\e[0m"
        
        sleep 1
    done
}

clear
# watch_time
show_time
