#!/bin/bash
path=$1
IFS=$'\n'
for item in $(ls -A ${path} | tr -d "\t")
do
if [ -d ${path}/${item} ]; then echo "${item} is folder"
elif [ -f ${path}/${item} ]; then echo "${item} is file"; fi
echo
done
