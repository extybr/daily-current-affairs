#!/usr/bin/env python
# $> ./numbers_gen.py 8914
# Генератор списка мобильных номеров

import sys

PREFIX = '+7999'
if len(sys.argv) == 2:
    PREFIX = sys.argv[1]

FILE = f'{PREFIX}0000000.dict'


def write_numbers(number=0, start=90000000):
    with open(file=FILE, mode='a') as file:
        while number <= 9999999:
            file.write(f'{PREFIX}{start + number}\n')
            number += 1


def write_numbers_suffix():
    with open(file=FILE, mode='a') as file:
        for suffix in range(10000000):
            file.write(f'{PREFIX}{suffix:07d}\n')


# write_numbers()
write_numbers_suffix()
