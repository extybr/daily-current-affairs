import requests
import sys
from bs4 import BeautifulSoup

if len(sys.argv) < 2 or len(sys.argv) > 4:
    exit(1)

src = sys.argv[1]
ignore = 0

if (len(sys.argv) == 3 and sys.argv[2] != 'h') or len(sys.argv) == 4:
    src = sys.argv[2]
    if sys.argv[1] == '1':
        ignore = 1

url = (f"https://reestr.rublacklist.net/ru/?status=1&gov=all"
       f"&date_start=&date_end=&q={src}")

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
}

response = requests.get(url, headers=headers)
response.raise_for_status()

soup = BeautifulSoup(response.text, "html.parser")
rows = soup.find_all("div", class_="table_row")

def get_urls() -> str:
    urls = ''
    for row in rows:
        site_td = row.find("div", class_="td_site")
        if site_td:
            a = site_td.find("a")
            if (a and (src in a.text.strip()) and ignore) or (a and a.text.strip() == src):
                record = ('https://reestr.rublacklist.net/api/v3/record/' + 
                          a['href'][11:-1])
                urls += record + ' '
    return urls


print(get_urls())

