#!/bin/bash
# $> ./reply_timeout.sh
# Вариант ограничения работы скрипта по времени

if read -t 10 -p "Enter your name: "
  then echo "Hello $REPLY, welcome to my program"
else echo "timeout ... bye, bye"
fi

