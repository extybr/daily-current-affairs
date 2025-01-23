#!/bin/bash
# Выводит нажатые клавиши

while read -sN1 ; do
  echo "${REPLY}";
  case "${REPLY}" in
    q) echo 'quit '; break;
  esac
done

