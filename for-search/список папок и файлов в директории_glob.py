import glob


def search(path, ext):
    ext = f'*.{ext}'
    folders = glob.glob(path + '/**/', recursive=True)
    print(folders)
    for folder in folders:
        print(folder)
        files = glob.glob(f'{folder}/{ext}')
        for file in files:
            print('   ', file)


directory = input('Путь к папке: ')
extension = input('Искомое расширение файла: ')
search(directory, extension)
