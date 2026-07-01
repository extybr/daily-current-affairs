#!/bin/bash
# user report

echo "==============================================="

while IFS=: read user uid home; do
    last_login=$(last -n 1 "$user" 2>/dev/null | head -n 1 | awk '{print $4,$5,$6,$7}')
    
    # Проверяем, что все 4 поля существуют
    if [[ -n "$last_login" && $(echo "$last_login" | awk '{print NF}') -eq 4 ]]; then
        echo -e "\e[33m$user\e[0m (UID: $uid) - Last login: \e[34m$last_login\e[0m"
    fi
    # Пользователей без логина просто пропускаем
done < <(cut -d: -f1,3,6 '/etc/passwd')

echo "==============================================="

