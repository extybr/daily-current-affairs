#!/bin/env python3
# $> ./encode_decode_base64.py
# Кодирование файла в base64 / изображение в текст
# Декодирование файла из base64 / текст в изображение
import base64
import sys
from pathlib import Path


def encode_b64(ext: str, name: Path, path: str) -> None:
    """
    Кодирование файла в base64 и сохранение в файл.
    :param ext: Расширение кодируемого файла.
    :param name: Полный путь для сохранения.
    :param path: Путь к кодируемому файлу.
    """
    with open(name, "w", encoding='utf-8') as f:
        with open(path, "rb") as file:
            f.write(f'{ext},{base64.b64encode(file.read()).decode("utf-8")}')
    print(f'Кодирование завершено. Файл сохранен: {name}')
    main()


def decode_b64(name: str, path: str) -> None:
    """
    Декодирование файла из base64.
    :param name: Имя файла для декодирования без расширения.
    :param path: Путь к декодируемому файлу.
    """
    with open(path, "r", encoding='utf-8') as f:
        txt = f.read()
        if ext := txt.split(",")[0]:
            name = f'{name}.{ext}'
        dec = base64.decodebytes(txt.split(",")[1].encode())
        with open(Path(path).parent / name, 'wb') as file:
            file.write(dec)
    print(f'Декодирование завершено. Файл сохранен: {Path(path).parent / name}')
    main()


def main() -> None:
    """
    Обработка пользовательского ввода.
    """
    try:
        print(f"\n{'-'*26}\nКодирование файла в base64\n{'-'*26}")
        user_ch = input("[~] Выберите действие:\n    "
                        "[1] Кодирование файла\n    "
                        "[2] Декодирование файла\n    "
                        "[3] Выход\n    "
                        ">>> ")
        match user_ch:
            case '1':
                path = input("[~] Введите путь к кодируемому файлу: ")
                if not Path(path).suffix:
                    encode_b64("", Path(path).parent / f'{Path(path).name}.dat', path)
                else:
                    encode_b64(Path(path).suffix[1:],
                               Path(path).parent /
                               f'{Path(path).name.split(Path(path).suffix)[0]}.dat', path)
            case '2':
                path = input("[~] Введите путь к декодируемому файлу: ")
                if not Path(path).suffix:
                    decode_b64(Path(path).name, path)
                else:
                    decode_b64(Path(path).name.split(Path(path).suffix)[0], path)
            case '3':
                raise KeyboardInterrupt
            case _:
                print('\nВаш выбор непонятен! Еще разок...\n')
                main()
    except KeyboardInterrupt:
        print(f"\nДо свидания!")
        sys.exit(0)


if __name__ == "__main__":
    main()
