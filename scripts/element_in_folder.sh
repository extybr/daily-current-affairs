#!/bin/bash
IFS=$'\n'
for item in ${HOME}/*
do
basename "${item}"
if [ -d ${item} ]; then echo "${item} is folder"
elif [ -f ${item} ]; then echo "${item} is file"; fi
echo
done
