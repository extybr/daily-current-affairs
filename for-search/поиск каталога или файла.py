import os
from collections.abc import Iterable


def gen_files_path(target: str, directory: str) -> Iterable[str]:
    try:
        for path, folders, files in os.walk(directory):
            for search_folder in folders:
                yield f'Каталог: {os.path.join(path, search_folder)}'
                if target in os.path.join(path, search_folder):
                    print(f'Каталог {target} найден')
                    return
            for search_file in files:
                yield f'Файл: {os.path.join(path, search_file)}'
                if target in os.path.join(path, search_file):
                    print(f'Файл {target} найден')
                    return
    except PermissionError as error:
        print('Доступ закрыт', error)


search = input('Введите искомую папку или файл: ')
mother_path = os.sep
for item in gen_files_path(search, mother_path):
    print(item)
    with open('file.txt', 'a', encoding='utf-8') as file:
        file.write(item + '\n')
		