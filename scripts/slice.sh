#!/bin/sh

text='Hello World'
if [[ "${text}" =~ ^(Hello|OK) ]]
then echo "Текст начинается со слова Hello или OK"
elif [[ "${text}" =~ (World)$ ]]
then echo "Текст заканчивается словом World"
fi

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


