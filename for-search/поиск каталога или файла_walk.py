import os
from collections.abc import Iterable


def gen_files_path(target: str, directory: str) -> Iterable[str]:
    try:
        for path, folders, files in os.walk(directory):
            for search_folder in folders:
                yield f'Папка: {os.path.join(path, search_folder)}'
                if target in os.path.join(path, search_folder):
                    print(f'Папка {target} найдена')
                    return
            for search_file in files:
                yield f'Файл: {os.path.join(path, search_file)}'
                if target in os.path.join(path, search_file):
                    print(f'Файл {target} найден')
                    return
    except PermissionError as error:
        print('Доступ закрыт', error)


mother_path = input('Каталог откуда начать поиск: ')
search = input('Введите искомую папку или файл: ')

if not (os.path.exists(mother_path) and os.path.isdir(mother_path)):
    print('Каталог не найден')
    exit(0)

for item in gen_files_path(search, mother_path):
    print(item)
    with open('file.txt', 'a', encoding='utf-8') as file:
        file.write(item + '\n')
