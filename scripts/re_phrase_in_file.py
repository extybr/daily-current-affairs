# python re_phrase_in_file.py filename phrase
# Поиск строк с определенным словом в файле

import re
import sys
import pathlib

if len(sys.argv) != 3:
    print("*** 2 parameters were expected ***")
    exit(0)

filename = sys.argv[1]
phrase = sys.argv[2]

if not pathlib.Path(filename).exists():
    print(f"Error: File '{filename}' not found.")
    exit(0)


def simple_grep(pattern, file):
    try:
        with open(file, 'r') as text:
            for line in text:
                if re.search(pattern, line):
                    print(line.strip())
    except FileNotFoundError:
        print(f"Error: File '{file}' not found.")


simple_grep(phrase, filename)
