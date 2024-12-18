#!/bin/python3
###########################################################
# $> ./recursive_folder_comparison.py folder-1 folder-2   #
###########################################################

import os
import sys

red = "\33[31m"
red_bold = "\33[1;31m"
yellow = "\033[33m"
blue = "\033[36m"
white = "\033[37m"
normal = "\33[0m"

if len(sys.argv) != 3:
    sys.exit(f"{red}Ожидалось 2 параметра, а передано {len(sys.argv) - 1}{normal}")

src= sys.argv[1]
dst = sys.argv[2]

print(f"\n{white}Сравнение файлов первой папки с файлами во второй по имени и размеру{normal}\n")


def dirs(source: str, destination: str) -> None:
    files_source = os.listdir(source)
    files_destination = os.listdir(destination)
    for file in files_source:
        path_src = os.path.abspath(f"{source}/{file}")
        if os.path.isfile(path_src):
            size_src = os.path.getsize(path_src)
            if file in files_destination:
                path_dst = os.path.abspath(f"{destination}/{file}")
                size_dst = os.path.getsize(path_dst)
                if size_src != size_dst:
                    print(size_src, path_src)
                    print(size_dst, path_dst)
                    print(f"{yellow}Файлы разные по размеру{normal}\n")
            else:
                print(size_src, path_src)
                print(f"{red}Файл отсутствует во второй папке{normal}\n")
        elif os.path.isdir(path_src):
            if os.path.exists(f"{destination}/{file}"):
                dirs(f"{source}/{file}", f"{destination}/{file}")
            else:
                print(f"{destination}/{file}\n{red_bold}Папка отсутствует во второй папке{normal}\n")


dirs(src, dst)

