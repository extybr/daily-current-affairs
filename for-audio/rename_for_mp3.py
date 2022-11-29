import os

# переименование файлов mp3, flac в текущей папке, срезание начала в названии, удаление повторов
extension = ['.mp3', '.flac']
for file in os.listdir():
    try:
        if [unit for unit in extension if file.endswith(unit)]:
            if file.split()[-1] in ['копия' + i for i in extension]:
                [os.rename(file, file.replace(file.split()[-1], '').replace(file.split()[-2], i).
                           replace(' ' + i, i)) for i in extension if file.endswith(i)]
                continue
            name = file
            for letter in file:
                if letter.istitle():
                    break
                else:
                    name = name[1:]
            os.rename(file, name)
    except FileExistsError:
        os.remove(file)
