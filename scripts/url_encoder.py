#!/bin/python3
# https://github.com/wayne931121/Python_URL_Decode
import sys

URL_RFC_3986 = {
"!": "%21", "#": "%23", "$": "%24", "&": "%26", "'": "%27", "(": "%28", ")": "%29", "*": "%2A", "+": "%2B", 
",": "%2C", "/": "%2F", ":": "%3A", ";": "%3B", "=": "%3D", "?": "%3F", "@": "%40", "[": "%5B", "]": "%5D",
}


def url_encoder(string: str) -> None:
    if type(string) == bytes:
        string = string.decode(encoding="utf-8")
    result = bytearray()
    for char in string:
        if char in URL_RFC_3986:
            for ch in URL_RFC_3986[char]:
                result.append(ord(ch))
            continue
        char = bytes(char, encoding="utf-8")
        if len(char) == 1:
            result.append(ord(char))
        else:
            for c in char:
                c = hex(c)[2:].upper()
                result.append(ord("%"))
                result.append(ord(c[0:1]))
                result.append(ord(c[1:2]))
    result = result.decode(encoding="ascii")
    print(result)
    

url_encoder(sys.argv[1])
