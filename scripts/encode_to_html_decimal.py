#!/usr/bin/python3

import sys
    

def encode_to_html_decimal(input_string: str) -> str:
    """
    Преобразует специальные символы текста в их HTML-десятичные коды.
    """
    return ''.join(f'&#{ord(char)};' if char in {',', '<', '>', '&'} else char for char in input_string)


if len(sys.argv) > 1:
    word = sys.argv[1]
    print(encode_to_html_decimal(word))

