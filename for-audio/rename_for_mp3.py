import os

# переименование файлов mp3 в текущей папке, срезание начала в названии
for items in os.listdir():
    if items.endswith('.mp3'):
        os.rename(items, str(items[4:]))
        print(items)