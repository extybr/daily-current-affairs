#!/bin/bash
# перейти в необходимую директорию с запутить оттуда скрипт
# есть проблема xargs с экранированием кавычек
# old='15. Music File.mp3'; new='Music File.mp3'
dir -1 | sed "p;s:^[0-9]\{1,3\}\.[\]\s::g" | xargs -n2 mv -i
# ls | sed "p;s:^[0-9]\{1,3\}\.[\]\s::g" | xargs -n2 -p mv -i

