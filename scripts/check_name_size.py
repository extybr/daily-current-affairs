#!/bin/python3
###############################################
# $> ./check_name_size.py folder-1 folder-2   #
###############################################

import os
import sys

red = "\33[31m"
yellow = "\033[33m"
blue = "\033[36m"
white = "\033[37m"
normal = "\33[0m"

if len(sys.argv) != 3:
    sys.exit(f"{red}Ожидалось 2 параметра, а передано {len(sys.argv) - 1}{normal}")

source = sys.argv[1]
destination = sys.argv[2]

print(f"\n{white}Сравнение файлов первой папки с файлами во второй по имени и размеру{normal}\n")

files_source = os.listdir(source)
files_destination = os.listdir(destination)
for file in files_source:
    path_src = os.path.abspath(f"{source}/{file}")
    if os.path.isfile(path_src):
        size_src = os.path.getsize(path_src)
        if file in files_destination:
            path_dst = os.path.abspath(f"{destination}/{file}")
            size_dst = os.path.getsize(path_dst)
            if size_src == size_dst:
                print(size_src, path_src) 
                print(size_dst, path_dst)
                print(f"{blue}Файлы идентичны{normal}\n")
            else:
                print(size_src, path_src)
                print(size_dst, path_dst)
                print(f"{yellow}Файлы разные по размеру{normal}\n")
        else:
            print(size_src, path_src)
            print(f"{red}Файл отсутствует во второй папке{normal}\n")

