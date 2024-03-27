import os


def function(n):
    count_files = 0
    count_folders = 0
    with open(file='my.txt', mode='a', encoding='utf-8') as f:
        for path, folder, file in os.walk(n):
            f.write(str(path) + '\n')
            for _ in folder:
                count_folders += 1
            for files in file:
                f.write(' ' * len(path) + f'\\{files}\n')
                count_files += 1
        f.write(f'Папок: {count_folders}\nФайлов: {count_files}')


with open(file='my.txt', mode='w', encoding='utf-8') as f:
    function(os.getcwd())
