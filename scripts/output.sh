#!/bin/bash
# $> ./output.sh
# Вывод stdout (1), stderr (2) и другое (xxx) в разные файлы

exec 1>message_normal.log
exec 2>message_error.log
exec 100>message_special.log

echo "errors output" >&2
echo "normal output"
echo "Hello World!" >&100

ls -l not_found_file.txt *.sh 1>ls_message.log 2>&1

