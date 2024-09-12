#!/bin/python3
import re
import subprocess

red = "\033[31m"
yellow = "\033[33m"
blue = "\033[36m"
normal = "\033[0m"

cmd = "curl -s --proxy n.thenewone.lol:29976 --max-time 10 --location "
number = 252
link = f"'https://rutracker.org/forum/viewforum.php?f={number}'"
html = subprocess.getoutput(cmd + link, encoding='cp1251')

if not html:
    print(f'{red}*** Fail ***{normal}')
    exit(0)

pattern = r'tt-\d{7}.+</a>'

result = re.compile(pattern).findall(html)

for item in result:
    url = 'https://rutracker.org/forum/' + item[18:41]
    title = item[73:-4].replace('<wbr>', '')
    print(f'{blue}{title}{normal}\n{yellow}{url}{normal}\n')
