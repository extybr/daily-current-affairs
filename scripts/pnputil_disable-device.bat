@echo off
::Отключение (включение) устройства (HID-совместимая сенсорная панель (ноутбучная мышка-джойстик))
pnputil /disable-device "HID\ELAN06FA&Col03\4&58d0b36&0&0002"
echo Device off
::pnputil /enable-device "HID\ELAN06FA&Col03\4&58d0b36&0&0002"
::echo Device on
cmd