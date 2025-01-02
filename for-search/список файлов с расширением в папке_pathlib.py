from pathlib import Path


def search(path: Path, ext: str) -> None:
    ext = f'*.{ext}'
    folders = Path(path).glob(ext)
    [print(folder) for folder in folders]


directory = Path(input('Путь к папке: '))

if not (directory.exists() and directory.is_dir()):
    print('Папка не найдена')
    exit(0)
    
extension = input('Искомое расширение файла: ')

search(directory, extension)
