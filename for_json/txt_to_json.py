import json
import requests

url = 'https://api.hh.ru/professional_roles'
response = requests.get(url)

with open('result.txt', 'w', encoding='utf-8') as file:
    file.write(response.text)

# для текст.файла
with open('result.txt', 'r', encoding='utf-8') as file:
    data = json.load(file)   # словарь одной строкой в файл # десериализация json
print(data)  # словарь одной строкой в консоль

info = json.dumps(data, indent=4)
print(info)  # печатаем json в консоль

with open('result.json', 'w') as file:
    json.dump(data, file, indent=4)  # печатаем json в файл  # сериализация json
