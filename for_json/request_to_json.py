import json
import requests

url = 'https://api.hh.ru/professional_roles'
response = requests.get(url)

data = json.loads(response.text)  # десериализация json
with open('output.json', 'w') as file:
    json.dump(data, file, indent=4)  # сериализация json
