#!/usr/bin/python3

import re
import sys
from pathlib import Path

if len(sys.argv) != 2:
    path = Path(input('Укажите путь к папке: '))
else:
    path = Path(sys.argv[1])

while not (path.is_dir() and path.exists()):
    path = Path(input('Укажите путь к папке: '))


pattern_webm = r'.+\[.+\].webm'
pattern_mp4 = r'.+\[.+\].mp4'
pattern_m4a = r'.+\[.+\].m4a'
pattern_mkv = r'.+\[.+\].mkv'
superfluous = (r'\s\[.{11}\]', r'\s\[-.{8}_.{9}\]')

try:
    for file in path.iterdir():
        for pattern in (pattern_webm, pattern_mp4, pattern_m4a, pattern_mkv):
            if str(file) in re.compile(pattern).findall(str(file)):
                for i in superfluous:
                    scrap = re.compile(i).findall(str(file))
                    if scrap:
                        filename = str(file).replace(scrap[0], '')
                        Path(file).rename(filename)
                        print(f"\033[37m{Path(filename).name}\033[0m")
except Exception as error:
    print(error)

