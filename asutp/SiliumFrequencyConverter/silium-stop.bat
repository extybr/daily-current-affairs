@echo off
mode con codepage select=1251 > nul
echo Управление частотником Силиум
echo Запуск...
python -c "import serial; ser=serial.Serial('COM8',9600); ser.write(b'\x01\x06\x20\x00\x00\x06\x02\x08'); ser.close()"
::cmd