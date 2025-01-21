#!/bin/bash
# перейти в необходимую директорию с запутить оттуда скрипт

function cutX {
  # есть проблема xargs с экранированием кавычек
  # old='15. Music File.mp3'; new='Music File.mp3'
  dir -1 | sed "p;s:^[0-9]\{1,3\}\.[\]\s::g" | xargs -n2 mv -i
  # ls | sed "p;s:^[0-9]\{1,3\}\.[\]\s::g" | xargs -n2 -p mv -i
}

function renameSuffix {
  # Переименовываем все файлы с указанным расширение в текущей папке
  for file in *.txt; do 
    mv $file ${file/txt/TXT}
  done
}

function cutN() {
  # Удаляем по n символов с имени каждого файла
  IFS=$'\n'; n=5; for i in $(ls -1); do
    mv "${i}" "${i/${i::$n}/}"
  done
}

function cutNum {
  touch {1..5}-filename.txt  # Создание файлов по шаблону
  # До: 1-filename.txt  2-filename.txt  3-filename.txt  4-filename.txt  5-filename.txt
  for i in $(ls -1); do
    mv "$i" "${i:0:6}.${i#*.}"  # Переименование срезом (удаляем name)
  done
  # После: 1-file.txt  2-file.txt  3-file.txt  4-file.txt  5-file.txt
}

function cutName {
  touch {1..5}" - file name.txt"   # Создание файлов по шаблону с пробельными символами
  # До: '1 - file name.txt'	'2 - file name.txt'	'3 - file name.txt'	'4 - file name.txt'	'5 - file name.txt'
  IFS=$'\n'; for i in $(ls -1); do
    mv -i "${i}" "${i/ name/}"  # Переименование по патерну (удаляем name)
    # mv -i "${i}" "${i:0:8}.${i#*.}"
  done
  # После: '1 - file.txt'  '2 - file.txt'  '3 - file.txt'  '4 - file.txt'  '5 - file.txt'
}

function cutSed {
  # Переименование последнего файла в списке по шаблону
  mv "$(ls -1 | tail -n 1)" "$(ls -1 | sed "p;s:^:000_:g" | tail -n 1)"
  mv "$(ls -1 | tail -n 1)" "$(ls -1 | sed "p;s:^...::g" | tail -n 1)"
}

count_files=$(ls -1 | wc -l)
echo "${count_files}"  # Количество файлов
last_file=$(ls -1 | tail -n +${count_files})
echo "${last_file}"  # Последний файл в списке
pre_last_file=$(ls -1 | tail -n +$[ "${count_files}" - 1 ] | head -n 1)
echo "${pre_last_file}"  # Предпоследний файл в списке

ls -1 | sed "p;s:^...::g" | tail -n 8 | head -n 2  # Вывод названия 4-го файла снизу списка и изменение имени по шаблону

for i in {1..$(ls -1 | wc -l)}; do ls -1 | tail -n $i | head -n 1; done  # Вывод имени файла по одному циклом

ls -1 | tail -n $(( $(ls -1 | wc -l)/2 + 1 )) | head -n 1  # Вывод файла с середины списка

