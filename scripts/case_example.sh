#!/bin/bash

##########################################

case "$1" in
  ./*) echo -n "local"       # Начинается с ./
    ;&                       # Спуститься к следующему варианту
  [^/]*) echo -n "-relative"  # Начинается с любого символа, кроме слеша
    ;;&                      # Проверить совпадения с другими вариантами
  /*) echo -n "-absolute"     # Начинается с символа слеша
    ;&                       # Спуститься к следующему варианту
  */*) echo "-pathname"       # В имени есть слеш
    ;;                       # Завершить
  *) echo "-filename"         # Все остальные случаи
    ;;                       # Завершить
esac

##########################################

case "$1" in
  [Nn][Oo]* )
    echo "Fine. Leave then."
    exit
  ;;
  [Yy]?? | [Ss]ure | [Oo][Kk]* )
    echo "OK. Glad we agree."
  ;;
  * ) echo 'Try again.'
  ;;
esac

##########################################

# Вывод файлов с сортировкой по длине, дате создания, размеру.

function error {
	echo -e "$0 \e[37mlast / len / long\e[0m"
	exit 1
}

function ls_length {
  IFS=$'\n'
  ls -1 "$@" | while read fn; do
    printf '%3d %s\n' ${#fn} ${fn}
  done | sort -n
}

(( "$#" < 1 )) && error

param="$1"
shift

case "${param}" in
  last)
    ls -lrt | tail "-n${1:-5}"
  ;;
  len)
    ls_length "$@"
  ;;
  long)
    ls_length "$@" | tail -1
  ;;
  *)
    echo -e "unknown command: \e[37m${param}\e[0m"
    error
  ;;
esac

