#!/bin/bash
# $> ./forever_print.sh

while_true() {
  while true; do
    printf 'forever'
  done
}

until_false() {
  until false; do
    printf 'forever'
  done
}

function forever {
  for ((;;)); do
    sleep 0.1
    printf 'forever'
  done
}

forever

