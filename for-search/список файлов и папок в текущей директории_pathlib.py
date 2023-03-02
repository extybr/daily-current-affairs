from pathlib import Path


def search(path):
    folders = Path(path)
    print(folders)
    for item in folders.iterdir():
        print('  ', item)
    for folder in folders.iterdir():
        if folder.is_dir():
            search(folder)


directory = input('Путь к папке: ')
search(directory)
