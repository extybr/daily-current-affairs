#!/bin/python3
# https://github.com/wayne931121/Python_URL_Decode
import sys


def url_decoder(string):
    if type(string) == bytes:
        string = string.decode("utf-8")
    result = bytearray()
    enter_hex_unicode_mode = 0
    hex_tmp = ""
    now_index = 0
    for char in string:
        if char == '%': 
            enter_hex_unicode_mode = 1
            continue
        if enter_hex_unicode_mode:
            hex_tmp += char
            now_index += 1
            if now_index == 2: 
                result.append(int(hex_tmp, 16) )
                hex_tmp = ""
                now_index = 0
                enter_hex_unicode_mode = 0
            continue
        result.append(ord(char))
    result = result.decode(encoding="utf-8")
    print(result)


url_decoder(sys.argv[1])
