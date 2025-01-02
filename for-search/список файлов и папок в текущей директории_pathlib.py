from pathlib import Path


def search(folders: Path) -> None:
    print(folders)
    for item in folders.iterdir():
        print('  ', item)
    for folder in folders.iterdir():
        if folder.is_dir():
            search(folder)


directory = Path(input('Путь к папке: '))

if not (directory.exists() and directory.is_dir()):
    print('Папка не найдена')
    exit(0)
    
search(directory)
