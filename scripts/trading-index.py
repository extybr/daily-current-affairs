#!/bin/python3
import requests
import re
import json

violet = "\033[35m"
yellow = "\033[33m"
blue = "\033[36m"
normal = "\033[0m"

url = 'https://ru.tradingview.com/markets/indices/quotes-major/'
html = requests.get(url).text
pattern = r'{"s":"SP:SPX"[^>]+"tot'
text = re.compile(pattern).findall(html)[0]
text_change = text.replace('],"tot', '').replace('},{', '}\n{')
data = text_change.split('\n')
for string in data:
    item = json.loads(string)
    print(f"index: {blue}{item['s']}{normal}   "
          f"title: {violet}{item['d'][1]}{normal}   "
          f"value: {yellow}{item['d'][6]}{normal}")

