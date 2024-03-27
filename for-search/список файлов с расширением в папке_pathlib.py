from pathlib import Path


def search(path, ext):
    ext = f'*.{ext}'
    folders = Path(path).glob(ext)
    [print(folder) for folder in folders]


directory = input('Путь к папке: ')
extension = input('Искомое расширение файла: ')
search(directory, extension)
