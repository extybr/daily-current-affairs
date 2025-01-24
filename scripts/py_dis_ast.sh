#!/bin/bash
# $> ./py_dis_ast.sh
# Дизассемблер и парсер python кода

WHITE='\e[37m'
NORM='\e[0m'

if [ "$#" -ne 1 ]; then
  echo -e "***${WHITE} Ожидалось 1 параметр ${NORM}***"
  exit
fi

SRC="$1"

line() {
  ch=$(printf "%30s")
  echo -e "\n${WHITE}${ch// /'*' }${NORM}\n"
}

function fn {
  python3 -m dis "$SRC"
  line
  python3 -m ast "$SRC"
}

function code {
  echo "$SRC" | python3 -m dis
  line
  echo "$SRC" | python3 -m ast
}

line

if [ -f "$SRC" ]; then
  fn
else code
fi

line

