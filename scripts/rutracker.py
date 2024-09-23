#!/bin/python3
#############################
# $> ./rutracker.py         #
# $> ./rutracker.py 0       #
# $> ./rutracker.py 252     #
# $> ./rutracker.py 1 252   #
# $> ./rutracker.py -h      #
#############################

import sys
import re
import subprocess

red = "\033[31m"
yellow = "\033[33m"
blue = "\033[36m"
normal = "\033[0m"

proxy = '--proxy n.thenewone.lol:29976 '
number = 252


def fail() -> None:
    print(f'{red}*** Fail ***{normal}')
    exit(0)


if len(sys.argv) == 2:
    if sys.argv[1] in ('h', '-h', 'help', '-help'):
        print(' 252 - Фильмы 2024 года\n 934 - Азиатские фильмы\n'
              ' 505 - Индийское кино\n 1803 - Новинки и сериалы в '
              'стадии показа (HD Video)')
        exit(0)
    elif sys.argv[1] == '0':
        proxy = ''
    elif sys.argv[1] == '1':
        pass
    else:
        number = sys.argv[1] if sys.argv[1].isdigit() else fail()
elif len(sys.argv) == 3:
    if sys.argv[1] == '0':
        proxy = ''
    number = sys.argv[2] if sys.argv[2].isdigit() else fail()

cmd = f"curl -s --max-time 10 --location {proxy}"
link = f"'https://rutracker.org/forum/viewforum.php?f={number}'"
html = subprocess.getoutput(cmd + link, encoding='cp1251')

if not html:
    fail()

pattern = r'tt-\d{7}.+</a>'

result = re.compile(pattern).findall(html)

for item in result:
    url = 'https://rutracker.org/forum/' + item[18:41]
    title = item[73:-4].replace('<wbr>', '')
    print(f'{blue}{title}{normal}\n{yellow}{url}{normal}\n')
