import glob


def search(path: str, ext: str) -> None:
    ext = f'*.{ext}'
    folders = glob.glob(path + '/**/', recursive=True)
    for folder in folders:
        print(folder)
        files = glob.glob(f'{folder}/{ext}')
        for file in files:
            print('   ', file)


directory = input('Путь к папке: ')
extension = input('Искомое расширение файла: ')
search(directory, extension)
