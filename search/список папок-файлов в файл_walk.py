import os

my_path = input('Путь до папки: ')

if not (os.path.exists(my_path) and os.path.isdir(my_path)):
    print('Папка не найдена')
    exit(0)

FILE = os.path.basename(my_path) + '.txt'


def function(directory: str) -> None:
    count_files = 0
    count_folders = 0
    with open(file=FILE, mode='a', encoding='utf-8') as f:
        for path, folder, file in os.walk(directory):
            f.write(str(path) + '\n')
            for _ in folder:
                count_folders += 1
            for files in file:
                f.write(' ' * len(path) + f'\\{files}\n')
                count_files += 1
        f.write(f'Папок: {count_folders}\nФайлов: {count_files}')


with open(file=FILE, mode='w', encoding='utf-8') as f:
    function(my_path)
