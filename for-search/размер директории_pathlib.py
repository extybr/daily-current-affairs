from pathlib import Path
from typing import Union


def calculate_directory_size(directory_path: Union[str, Path] = ".") -> int:
    print(f'Переданный вами путь: {directory_path}')
    home = Path.home()
    size = 0
    try:
        for item in Path(home, directory_path).glob("**/*"):
            size += item.stat().st_size
        if size == 0:
            raise ValueError
    except ValueError:
        print('Вы передали либо: 1. Несуществующий путь \n'
              '                  2. Это не директория \n'
              '                  3. Директория пуста')
    return size
    

my_path = input('Путь до папки: ')

directory_size = calculate_directory_size(my_path)
print(f'Размер папки: \033[36m{directory_size:,}\033[0m Bytes')

