#!/bin/python3
import re
import subprocess

red = "\33[31m"
yellow = "\033[33m"
blue = "\033[36m"
normal = "\33[0m"


def get_proxy() -> str:
    """ Not used """
    cmd = ("curl -s --location --max-time 7 "
           "'https://p.thenewone.lol:8443/proxy.pac' "
           "| tail -n 10 | grep PROXY | awk '{print $3}' | sed 's/;//g'")
    proxy = subprocess.getoutput(cmd)
    return proxy


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