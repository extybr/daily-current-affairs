#!/bin/sh

cd ~/PycharmProjects/temp/map_with_customtkinter
if [ "$#" -gt 1 ]
  then echo "ожидалось не более 1 параметра, а передано $#"
elif [ "$#" -eq 1 ]
  then venv/bin/python main.py "$1"
else venv/bin/python main.py
fi
