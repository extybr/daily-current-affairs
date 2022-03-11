import time
from datetime import datetime, date

print(time.asctime()[11:19])
print('time.asctime():', time.asctime())
print('time.ctime():', time.ctime())

print(time.localtime())
if time.localtime().tm_year == 2022:
    print(f'time: {time.localtime().tm_hour}:{time.localtime().tm_min}')

print('datetime.now():', datetime.now())
print('datetime.today():', datetime.today())

print(time.strftime('%X %x %Z'))
print(date.fromtimestamp(time.time()))
print(f'time: {time.localtime().tm_year}:{time.localtime().tm_mon}:{time.localtime().tm_mday}')

d = ["понедельник", "вторник", "среда", "четверг", "пятница", "суббота", "воскресенье"]
m = ["", "января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября",
     "октября", "ноября", "декабря"]
t = time.localtime()   # Получаем текущее  время
print("Сегодня:\n%s %s %s %s %02d:%02d:%02d\n%02d.%02d.%02d" % (d[t[6]], t[2], m[t[1]], t[0],
                                                                t[3], t[4], t[5], t[2], t[1], t[0]))

temp = str(datetime.today())[14:16]
while int(temp) + 1 != int(str(datetime.today())[14:16]):
    print(temp, end=' ')
    time.sleep(1)
