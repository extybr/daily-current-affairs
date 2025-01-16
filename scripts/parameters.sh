#!/bin/sh
# ./parameters.sh first second third fourth
echo "Количество параметров: $#"
echo "Перечисление параметров одной строкой: $*"
echo "Перечисление параметров по одному (в массиве): $@"

array=($@)
for (( i=0; i<$#; i++ ))
do
  echo "$(( i+1 ))-й параметр: ${array[i]}"
done

echo "Код возврата последней команды: $?"
echo "PID процесса: $$"
echo "Hello"
echo "Последний вывод: $_"

function Listem {
  for arg; do
    echo "arg to func: '$arg'"
  done
  echo "Inside func: \$0 is still: '$0'"
}

Listem 0 1 2 3 $*

