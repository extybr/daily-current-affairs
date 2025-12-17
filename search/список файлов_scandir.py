import os


def scan(path: str) -> None:
    try:
        for items in os.scandir(path):
            fullpath = os.path.abspath(os.path.join(path, items))
            print(fullpath)
            if os.path.isdir(items):
                scan(items)
    except BaseException as error:
        print(error)


my_path = input('Путь до папки: ')

if not (os.path.exists(my_path) and os.path.isdir(my_path)):
    print('Папка не найдена')
    exit(0)
    
scan(my_path)
