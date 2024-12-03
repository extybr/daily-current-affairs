#!/usr/bin/python3

import re
import sys
from pathlib import Path

path = sys.argv[1]

pattern_webm = r'.+\[.+\].webm'
pattern_mp4 = r'.+\[.+\].mp4'
pattern_m4a = r'.+\[.+\].m4a'
pattern_mkv = r'.+\[.+\].mkv'
superfluous = r'\s\[.{11}\]'

try:
    for file in Path(path).iterdir():
        for pattern in (pattern_webm, pattern_mp4, pattern_m4a, pattern_mkv):
            if str(file) in re.compile(pattern).findall(str(file)):
                scrap = re.compile(superfluous).findall(str(file))
                if scrap:
                    filename = str(file).replace(scrap[0], '')
                    Path(file).rename(filename)
                    print(f"\033[37m{Path(filename).name}\033[0m")
except Exception as error:
    print(error)

