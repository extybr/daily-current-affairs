#!/bin/python3
import requests
import re
import json

violet = "\033[35m"
yellow = "\033[33m"
blue = "\033[36m"
white = "\033[37m"
normal = "\033[0m"

url = 'https://ru.tradingview.com/markets/indices/quotes-major/'
html = requests.get(url).text
pattern = r'{"s":"SP:SPX"[^>]+"tot'
text = re.compile(pattern).findall(html)[0]
text_change = text.replace('],"tot', '').replace('},{', '}\n{')
data = text_change.split('\n')

print(f"+----------------+-----------------------------------------------+"
      f"----------------+\n"
      f"+     {white}index{normal}      +                    {white}title"
      f"{normal}                      +      {white}value{normal}     +\n"
      f"+----------------+-----------------------------------------------+"
      f"----------------+")

for string in data:
    item = json.loads(string)
    print(f"{blue}{item['s'].center(17, ' ')}{normal}"
          f"{violet}{item['d'][1].center(48, ' ')}{normal}"
          f"{yellow}{str(item['d'][6]).center(18, ' ')}{normal}")

print(f' {white}traidingview{normal} '.center(92, '*'))

