#!/bin/bash
IFS=$'\n'
file="${HOME}/.bash_history"
for var in $(cat ${file})
do
echo "${var}"
done
