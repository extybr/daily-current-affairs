from os import path, scandir


def scan(directory, folder, file, size):
    for i in scandir(directory):
        fullpath = path.abspath(i)
        if path.isfile(i):
            print(f'    {fullpath}')
            file += 1
            size += path.getsize(i)
    for i in scandir(directory):
        fullpath = path.abspath(i)
        if path.isdir(i):
            print(fullpath)
            folder += 1
            folder, file, size = scan(i, folder, file, size)
    return folder, file, size


search = input('Путь к папке: ')
count = scan(search, folder=0, file=0, size=0)
print(f'\nКол-во папок: {count[0]}\nКол-во файлов: {count[1]}\nОбщий размер: '
      f'{round(count[2]/1024/1024, 3)} MB')
