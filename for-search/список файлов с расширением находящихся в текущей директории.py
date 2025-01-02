import os
import fnmatch

directory = input('Путь к папке: ')
extension = input('Искомое расширение файла: ')

for fname in os.listdir(directory):
    # Если у текущего имени файла, указанное расширение, то печатаем его
    if fnmatch.fnmatch(fname, f'*.{extension}'):
        print(fname)
