import os

# переименование файлов mp3, flac в текущей папке, срезание начала в названии, удаление повторов
extension = ['.mp3', '.flac']
count_file, good_file, delete_file, rename_file = 0, 0, 0, 0
for file in os.listdir():
    try:
        if [unit for unit in extension if file.endswith(unit)]:
            count_file += 1
            if file.split()[-1] in ['копия' + i for i in extension]:
                [os.rename(file, file.replace(file.split()[-1], '').replace(file.split()[-2], i).
                           replace(' ' + i, i)) for i in extension if file.endswith(i)]
                continue
            if file[0].istitle():
                good_file += 1
                continue
            name = file
            for letter in file:
                if letter.istitle():
                    rename_file += 1
                    break
                else:
                    name = name[1:]
            os.rename(file, name)
    except FileExistsError:
        os.remove(file)
        delete_file += 1
print('Всего было аудиофайлов:', count_file)
print('Осталось аудиофайлов:', good_file + rename_file)
print('Удалено', delete_file, 'файлов')
print('Переименовано', rename_file, 'файлов')
