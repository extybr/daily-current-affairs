#!/bin/env python3
# $> ./convert_number.py 101a
# Перевод чисел в(из) разные системы счисления
import sys

if len(sys.argv) != 2:
    exit('нет данных')

number = sys.argv[1]

for i in number:
    if not i.isdigit() and i.lower() not in ['a', 'b', 'c', 'd', 'e', 'f']:
        exit('неверные данные')

# Преобразование в разные системы счисления
for name, func in {"Двоичный": bin, "Восьмеричный": oct, "Шестнадцатеричный": hex}.items():
    try:
        print(f"{name}: {func(int(number))[2:]}")
    except:
        pass

# Преобразование из разных систем счисления
for name, base in {"Из двоичного": 2, "Из восьмеричного": 8, "Из шестнадцатеричного": 16}.items():
    try:
        print(f"{name}: {int(number, base)}")
    except:
        pass
