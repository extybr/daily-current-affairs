#!/bin/bash
# Для циклического запуска программы sl
trap "echo ' Trapped Ctrl-C'; exit 0" SIGINT
while true
  #for ((i=0; i<10; i++));
  do
    sl -ae
    #/usr/games/sl -aelF
  done
