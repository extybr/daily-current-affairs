#!/bin/bash
# Пароль. В открытом виде. В командной строке. Пример:
# sshpass -p 'Qwerty123' ssh admin@10.0.5.21

# Как искать такие случаи

ps -eo pid,user,command --no-header | while read PID USER CMD; do
  if [[ "$CMD" =~ -p ]] || [[ "$CMD" =~ -pw ]] || [[ "$CMD" =~ --password= ]] || [[ "$CMD" =~ /password= ]]; then
    echo "PID=$PID USER=$USER CMD=$CMD"
  fi
done

