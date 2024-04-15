#!/bin/sh
if [ $#  -ne 1 ]
  then echo "необходимо передать текст/буквы для среза"
  exit 0
fi

text="Hello World"  # основной текст, который нужно обрезать
result_before=${text%"$1"*}  # срез основного текста до переданного символа/слова
result_after=${text#*"$1"}  # срез основного текста после переданного символа/слова

echo "${text}"
echo "before: ${result_before}"
echo "after: ${result_after}"

