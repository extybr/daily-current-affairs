# Переименование файлов mp3, flac в текущей папке, 
# срезание начала в названии, удаление повторов, 
# подсчет удаленных и переименованных файлов.
# Пример: "01. My audio file.mp3" -> "My audio file.mp3"
# $> python3 ~/script/rename_audio_files.py '/home/user/Music/my-folder' 

import os
import sys

if len(sys.argv) == 2:
    path = sys.argv[1]
    if not os.path.exists(path) or not os.path.isdir(path):
        print('Путь не найден')
        exit(0)
else:
    print('Необходимо указать путь к папке')
    exit(0)

extension = ['.mp3', '.flac']
count_file, good_file, delete_file, rename_file = 0, 0, 0, 0
for file in os.listdir(path):
    try:
        _, ext = os.path.splitext(file)
        if ext.strip() in extension:
            abs_path = os.path.join(path, file)
            count_file += 1
            if file.split()[-1].lower() in '(копия)' + ext:
                os.rename(abs_path, abs_path.replace(
                    file.split()[-1], '').strip() + ext)
                delete_file += 1
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
            if not name:
                good_file += 1
                continue
            os.rename(os.path.join(path, file), os.path.join(path, name))
    except FileExistsError:
        os.remove(file)
        delete_file += 1
print('Всего было аудиофайлов:', count_file)
print('Осталось аудиофайлов:', good_file + rename_file)
print('Удалено', delete_file, 'файлов')
print('Переименовано', rename_file, 'файлов')

