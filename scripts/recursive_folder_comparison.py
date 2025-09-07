#!/usr/bin/env python3
###########################################################
# $> ./recursive_folder_comparison.py folder-1 folder-2   #
###########################################################
# Сравнение файлов первой папки с файлами во второй по имени и размеру

import os
import sys
import shutil

red = "\33[31m"
red_bold = "\33[1;31m"
yellow = "\033[33m"
blue = "\033[36m"
white = "\033[37m"
normal = "\33[0m"

if len(sys.argv) != 3:
    parameters =  len(sys.argv) - 1
    sys.exit(f"{red}Ожидалось 2 параметра, а передано {parameters}{normal}")

src= sys.argv[1]
dst = sys.argv[2]

if not (os.path.isdir(src) and os.path.isdir(dst) and 
    os.path.exists(src) and os.path.exists(dst)):
    sys.exit(f"{red}Ошибка в указании пути папок{normal}")

data = []
print(f"\n{white}Сравнение файлов первой папки с файлами во второй по "
      f"имени и размеру{normal}\n")


def dirs(source: str, destination: str) -> None:
    global data
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
                    data.append((path_src, path_dst))
            else:
                print(size_src, path_src)
                print(f"{red}Файл отсутствует во второй папке{normal}\n")
                data.append((path_src, 'file'))
        elif os.path.isdir(path_src):
            if os.path.exists(f"{destination}/{file}"):
                dirs(f"{source}/{file}", f"{destination}/{file}")
            else:
                print(f"{source}/{file}\n{destination}\n{red_bold}"
                      f"Папка отсутствует во второй папке{normal}\n")
                data.append((f"{source}/{file}", 'folder'))
    

dirs(src, dst)

answer = input(f'\n{blue}Копировать из первой папки во вторую отсутствующие '
               f'файлы? (y/n)\nОтвет:{normal} ')
if answer == 'y':
   replacement = input(f'\n{blue}1 Копировать только папки'
                       f'\n2 Копировать только отсутствующие файлы'
                       f'\n3 Копировать все, кроме файлов разных по размеру'
                       f'\n4 Копировать все (папки, отсутствующие файлы и '
                       f'файлы разные по размеру, с заменой)'
                       f'\nОтвет (выбор цифры пункта):{normal} ')
else:
   exit(0)


def path_dst(dirname: str) -> str:
    global src, dst
    basename = ''
    base = dirname.replace(src, '').split('/')
    for word in base:
        if not word:
            continue
        else:
            if os.path.exists(f'{dst}/{word}'):
                basename += f'/{word}'
    return dst + basename


def copy_folder() -> None:
    global data, dst
    for item in data:
        if item[1] == 'folder':
            folder = os.path.basename(item[0])
            shutil.copytree(item[0], f"{dst}/{folder}")


def copy_file() -> None:
    global data, dst
    for item in data:
        if item[1] == 'file':
            new_dst_path = path_dst(os.path.dirname(item[0]))
            shutil.copy(item[0], new_dst_path)


def copy_files() -> None:
    global data, dst
    for item in data:
        if item[1] == 'folder':
            folder = os.path.basename(item[0])
            shutil.copytree(item[0], f"{dst}/{folder}")
        elif item[1] == 'file':
            new_dst_path = path_dst(os.path.dirname(item[0]))
            shutil.copy(item[0], new_dst_path)


def copy_all() -> None:
    global data, dst
    for item in data:
        if item[1] == 'folder':
            folder = os.path.basename(item[0])
            shutil.copytree(item[0], f"{dst}/{folder}")
        elif item[1] == 'file':
            new_dst_path = path_dst(os.path.dirname(item[0]))
            shutil.copy(item[0], new_dst_path)
        else:
            shutil.copyfile(item[0], item[1])


choice = {'1': copy_folder,
          '2': copy_file,
          '3': copy_files,
          '4': copy_all}

if replacement in '1234':
    choice[replacement]()
    print(f'{blue}Все файлы скопированы{normal}')
else:
    exit(0)

