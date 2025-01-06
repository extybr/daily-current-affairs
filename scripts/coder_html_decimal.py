#!/usr/bin/python
# $> ./coder_html_decimal.py 'Обновление &#8220;Избранного&#8221;'

import re
import sys


def encode_to_html_decimal(input_string: str) -> str:
    """
    Преобразует специальные символы текста в их HTML-десятичные коды.
    """
    return ''.join(f'&#{ord(char)};' if char in {',', '<', '>', '&'} else char for char in input_string)


def decode_decimal_only(input_string: str) -> str:
    """
    Декодирует только десятичные HTML-коды вида &#123;.
    """
    def replace_entity(match):
        char_code = int(match.group(1))
        return chr(char_code)
    
    return re.sub(r"&#(\d+);", replace_entity, input_string)


coder = {'encoder': encode_to_html_decimal, 'decoder': decode_decimal_only}

if len(sys.argv) > 2:
    print(coder.get(sys.argv[1], {})(sys.argv[2]))

