#!/usr/bin/python
import os

my_path = input('Путь до папки: ')

if not (os.path.exists(my_path) and os.path.isdir(my_path)):
    print('Папка не найдена')
    exit(0)

root_size = 0
count_folders = 0
count_files = 0

for root, dirs, files in os.walk(my_path):
    print(root, "содержит", end=" ")
    dir_size = sum(os.path.getsize(os.path.join(root, name)) for name in files)
    root_size += dir_size
    print(dir_size, end=" ")
    print("байт в", len(files), "файлах")
    count_files += len(files)
    count_folders += len(dirs)

print('\nКоличество папок: {}'.format(count_folders))
print('Количество файлов: {}'.format(count_files))
print('Размер всех файлов: {:,d} Байт'.format(root_size))

