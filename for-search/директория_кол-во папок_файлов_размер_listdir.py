import os


def gen_files_path(path, count, size, folder):
    for i in os.listdir(path):
        j = os.path.abspath(os.path.join(path, i))
        if os.path.isfile(j) or os.path.islink(j):
            count += 1
            size += os.path.getsize(j)
            if not (str(j.lower()).endswith('.jpg') or str(j.lower()).endswith('.png')):
                with open('file.txt', 'a', encoding='utf-8') as file:
                    file.write(f'    {i}\n')  # имя файла
                    # file.write(f'    {j}\n')  # полный путь файла
        else:
            with open('file.txt', 'a', encoding='utf-8') as file:
                file.write(f'{i}' + '\n')  # имя папки
                # file.write(f'{i}' + '\n')  # полный путь папки
            folder += 1
            count, size, folder = gen_files_path(j, count, size, folder)
    return count, size, folder


my_path = input('Путь до папки: ')

if not (os.path.exists(my_path) and os.path.isdir(my_path)):
    print('Папка не найдена')
    exit(0)

a, b, c = gen_files_path(my_path, 0, 0, 0)
result = f'Кол-во папок: {c}\nКол-во файлов: {a}\n' + 'Размер директории: {:,d}_Byte'.format(b)
print(result)
with open('file.txt', 'a', encoding='utf-8') as file:
	file.write(result)
