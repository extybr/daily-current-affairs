#!/usr/bin/python
# $> ./decode_html_decimal.py 'Обновление &#8220;Избранного&#8221;'

import re
import sys


def decode_decimal_only(input_string: str) -> str:
    """
    Декодирует только десятичные HTML-коды вида &#123;.
    """
    def replace_entity(match):
        char_code = int(match.group(1))
        return chr(char_code)
    
    return re.sub(r"&#(\d+);", replace_entity, input_string)


html_code = sys.argv[1]
if len(sys.argv) > 1:
    print(decode_decimal_only(html_code))

