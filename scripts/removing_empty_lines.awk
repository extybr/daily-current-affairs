#!/bin/gawk -f
# Удаляет все пустые строки

# Сначала проверяем есть ли параметр и сам файл
BEGIN{if(ARGC<2){print "Ошибка: укажите имя файла" > "/dev/stderr"; exit 1};
if(system("test -f \"" ARGV[1] "\"")!=0){print "Файл не найден: " ARGV[1] > "/dev/stderr"; exit 1}}

# Вывод в консоль
# NF  # вариант 1
# $0 != "" {print}  # вариант 2
# !/^[[:space:]]*$/ { print }  # вариант 3
# {if($0!="")lines[++n]=$0} END{for(i=1;i<=n;i++)print lines[i]}  # вариант 4

# сохранение результата в файле
# BEGIN{f=ARGV[1];ARGC=1;while(getline<f>0)if($0!~/^[[:space:]]*$/)a[++n]=$0;close(f);for(i=1;i<=n;i++)print a[i]>f;close(f)}

# Сохранение результата в файле. Без массива (если файл большой)
BEGIN{file = ARGV[1];ARGC = 1;while((getline<file)>0){if($0!~/^[[:space:]]*$/)count++};close(file);while((getline line<file)>0){if (line !~ /^[[:space:]]*$/){print line>file}};close(file)}

# Без массива, с временным файлом
# BEGIN{file=ARGV[1];tmp=file ".tmp";ARGC=1;while((getline line<file)>0){if(line !~ /^[[:space:]]*$/){print line>tmp}};close(file);close(tmp);system("mv \"" tmp "\" \"" file "\"")}

# Для ОЧЕНЬ больших файлов (потоковая обработка)
# BEGIN{file=ARGV[1];tmp=file ".tmp." PROCINFO["pid"];ARGC=1;cmd="awk '!/^[[:space:]]*\\$/ {print}' \"" file "\" > \"" tmp "\"";if(system(cmd)==0){system("mv \"" tmp "\" \"" file "\"")}else{system("rm -f \"" tmp "\"");exit 1}}

# Просто печать с пояснением
BEGIN {
print "BEGIN{"
print "      f=ARGV[1];                # сохраняем имя файла"
print "      ARGC=1;                   # отменяем стандартную обработку файла awk" 
print "        # Читаем файл и фильтруем пустые строки"
print "      while(getline<f>0)"
print "      if($0!~/^[[:space:]]*$/)  # если строка не пустая"
print "      a[++n]=$0;                # сохраняем в массив" 
print "      close(f);                 # закрываем файл после чтения"  
print "        # Перезаписываем файл без пустых строк"
print "      for(i=1;i<=n;i++)"
print "      print a[i]>f;             # записываем в исходный файл"  
print "      close(f);                 # закрываем файл после записи"
print "}"
}

# Удаляет строки ДО хотя бы первых 2-х пустых строк, вывод в консоль
# /^[[:space:]]*$/ {empty++;if (empty >= 2) start = 1;next}{empty = 0;if (start) print}  # вариант 1
# /^[[:space:]]*$/{if(++e>=2)skip=1;next} {e=0} skip{print}  # вариант 2


