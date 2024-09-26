#!/bin/python3
############################
# $> ./pornolab.py         #
# $> ./pornolab.py 0       #
# $> ./pornolab.py 0 1867  #
# $> ./pornolab.py 1867    #
# $> ./pornolab.py -h      #
############################

import sys
import re
import subprocess

red = "\033[31m"
yellow = "\033[33m"
blue = "\033[36m"
normal = "\033[0m"

proxy = subprocess.getoutput('~/PycharmProjects/github/daily-'
                             'current-affairs/scripts/./proxy.sh')
number = 1867


def fail() -> None:
    print(f'{red}*** Fail ***{normal}')
    exit(0)


if len(sys.argv) == 2:
    if sys.argv[1] in ('h', '-h', 'help', '-help'):
        print(" 1867 - Сайтрипы 2024 (HD Video) / SiteRip's 2024 (HD Video)\n"
              " 883 - Эротические студии Разное / Erotic Picture Gallery "
              "(various)\n 1726 - MetArt & MetModels")
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
elif len(sys.argv) > 3:
    fail()

cmd = f"curl -s {proxy} --max-time 10 --location "
link = f"'https://pornolab.net/forum/viewforum.php?f={number}'"
html = subprocess.getoutput(cmd + link, encoding='cp1251')

if not html:
    fail()

pattern = r'.+tt-text.+</a>'
result = re.compile(pattern).findall(html)

for item in result:
    url = 'https://pornolab.net/forum/' + item[13:36]
    title = item[65:-4].replace('<wbr>', '')
    print(f'{blue}{title}{normal}\n{yellow}{url}{normal}\n')

