# Переименовывает файлы в папке по шаблону, с учетом возможных повторов
# Пример: my-video.mp4 -> pattern-10.mp4
# python3 ~/script/rename_file.py ~/Video/my-folder

import sys
from pathlib import Path

if len(sys.argv) == 2:
    path = Path(sys.argv[1]).expanduser()
    if not (path.exists() and path.is_dir()):
        print('Путь не найден')
        exit(0)
else:
    print('Необходимо указать путь к папке')
    exit(0)

prefix = 'mypattern-'
count = 0
files_path = list(path.glob('*'))

for file in files_path:
    abspath = Path(path / file)
    if abspath.is_file() and file.suffix != '.py':
        count += 1
        new_file_name = '{}/{}{}{}'.format(path, prefix, count, file.suffix)
        abspath.rename(new_file_name)

with open(sys.argv[0], 'r', encoding='utf8') as text:
    if '00' not in prefix:
        prefix_fix = text.read().replace(prefix, f"{prefix}00")
    else:
        prefix_fix = text.read().replace(prefix, prefix.replace('00', ''))

with open(sys.argv[0], 'w', encoding='utf8') as text:
    text.write(prefix_fix)
    
print(f'Переименовано \033[37m{count}\033[0m файлов')

