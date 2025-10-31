# silium
# hex-code: 01 03 00 00 00 0A C5 CD
#  01 - адрес устройства
#  03 - функция чтения Holding Registers
#  00 00 - начальный адрес
#  00 0A - количество регистров (10)
#  C5 CD - CRC

import serial
import time

PORT = 'COM8'  # Настройки порта
BAUDRATE = 9600  # Скорость обмена

# Команды в HEX
COMMANDS = {
    'start': bytes.fromhex('01 06 20 00 00 01 43 CA'),
    'revers': bytes.fromhex('01 06 20 00 00 02 03 CB'),
    'stop': bytes.fromhex('01 06 20 00 00 06 02 08'),
    'discret_control': bytes.fromhex('01 06 A3 02 00 01 CB 8E'),
    'com_control': bytes.fromhex('01 06 A3 02 00 02 8B 8F'),
    'freq_AI_control': bytes.fromhex('01 06 A3 03 00 02 DA 4F'),
    'freq_com_control': bytes.fromhex('01 06 A3 03 00 09 9B 88'),
}


def open_port():
    # Открываем порт
    ser = serial.Serial(
        port=PORT,
        baudrate=BAUDRATE,
        bytesize=8,
        parity='N',
        stopbits=1,
        timeout=1
    )
    return ser


def emergency_stop():
    """Аварийная остановка через разные команды"""
    emergency_commands = [
        '01 06 20 00 00 05 42 09',  # свободный останов
        '01 06 20 00 00 06 02 08',  # останов с замедлением  
    ]
    
    for cmd in emergency_commands:
        ser = open_port()
        ser.write(bytes.fromhex(cmd))
        time.sleep(0.5)
        ser.close()


def send_command(cmd_name: str) -> bool:
    try:
        # Открываем порт
        ser = open_port()
        
        # Отправляем команду
        command = COMMANDS[cmd_name]
        ser.write(command)
        print(f"Отправлено: {command.hex().upper()} - {cmd_name}")
        
        # Читаем ответ (если есть)
        time.sleep(0.1)
        response = ser.read(10)
        if response:
            print(f"Получено: {response.hex().upper()}")
        
        ser.close()
        return True
        
    except Exception as e:
        print(f"Ошибка: {e}")
        return False

		
def read_multiple_params() -> None:
    print("=== ЧТЕНИЕ ПАРАМЕТРОВ ЧАСТОТНИКА ===")
    
    params = {
        'frequency': ('1001', 'Текущая частота', 'Гц', 0.01),      # 1001 = 256 → 2.56 Гц
        'output_current': ('1004', 'Текущий ток', 'А', 0.1),       # в формате 0.1 А
        'dc_voltage': ('1002', 'Напряжение шины постоянного тока', 'В', 0.1), # в формате 0.1 В  
        'output_voltage': ('1003', 'Выходное напряжение', 'В', 0.1), # в формате 0.1 В
        'output_power': ('1005', 'Выходная мощность', 'кВт', 0.01), # в формате 0.01 кВт
        'output_torque': ('1006', 'Выходной момент', '%', 1.0), # в %
        'motor_speed': ('1007', 'Скорость двигателя', 'об/мин', 0.3), # об/мин
		'current_AI1': ('100A', 'Ток/Напряжение AI1', 'В/mA', 0.01), # в В (mA)
		'main_display': ('101F', 'Основной дисплей частоты X', 'Гц', 0.01), # в Гц
		'add_display': ('1020', 'Вспомогательная частота Y', 'Гц', 1.0), # в Гц
        'freq_display': ('7001', 'Чтение основной дисплей частоты с 7001 регистра', 'Гц', 0.01), # в Гц 
    }
    
    try:
        ser = open_port()
        
        for name, (address_hex, desc, unit, multiplier) in params.items():
            address = int(address_hex, 16)
            
            # Формируем команду чтения
            cmd = bytearray([0x01, 0x03, (address >> 8) & 0xFF, address & 0xFF, 0x00, 0x01])
            
            # Расчет CRC16 Modbus
            crc = 0xFFFF
            for byte in cmd:
                crc ^= byte
                for _ in range(8):
                    if crc & 0x0001:
                        crc = (crc >> 1) ^ 0xA001
                    else:
                        crc = crc >> 1
            
            cmd.append(crc & 0xFF)
            cmd.append((crc >> 8) & 0xFF)
            
            # Отправка команды
            ser.write(cmd)
            
            # Чтение ответа
            response = ser.read(7)
            
            if len(response) == 7:
                # Парсим данные (байты 3-4)
                raw_value = int.from_bytes(response[3:5], byteorder='big')
                real_value = raw_value * multiplier
                print(f"{desc}: {real_value:.2f} {unit}")
            else:
                print(f"{desc}: ОШИБКА ЧТЕНИЯ")
            
            # Пауза между запросами
            time.sleep(0.2)
        
        ser.close()
        
    except Exception as e:
        print(f"Ошибка связи: {e}")


def get_crc(data_hex):
    # Убеждаемся, что строка без пробелов и четной длины
    clean_hex = data_hex.replace(' ', '')
    if len(clean_hex) % 2 != 0:
        clean_hex = '0' + clean_hex  # Добавляем ведущий ноль
    data = bytes.fromhex(clean_hex)
    crc = 0xFFFF
    for byte in data:
        crc ^= byte
        for _ in range(8):
            if crc & 0x0001:
                crc = (crc >> 1) ^ 0xA001
            else:
                crc >>= 1
    return crc.to_bytes(2, 'little').hex().upper()


def change_freq(freq_hz: int) -> None:
    if not (0 <= freq_hz <= 50):
        print("Ошибка: частота должна быть от 0 до 50 Гц")
        return

    send_command('freq_com_control')
    
    # Правильное преобразование: 1 Гц = 200 единиц (0.02 Гц)
    freq_value = freq_hz * 200
    
    # Преобразуем в HEX
    num_hex = f"{freq_value:04X}"
    
    # Формируем команду
    data_for_crc = f"01061000{num_hex}"  # Без пробелов для расчета CRC
    crc = get_crc(data_for_crc)
    
    # Полная команда с пробелами
    full_command = f"01 06 10 00 {num_hex[:2]} {num_hex[2:]} {crc[:2]} {crc[2:]}"
    
    # bytes.fromhex('01 06 10 00 17 70 83 1E'),  # hex 1770 = dec 6000, где 60 / 2 = 30 Гц
    # bytes.fromhex('01 06 10 00 27 10 97 36'),  # hex 2710 = dec 10000, где 100 / 2 = 50 Гц
    # bytes.fromhex('01 06 10 00 03 E8 8D B4'),  # hex 03E8 = dec 1000, где 10 / 2 = 5 Гц 
	
    # Отправка
    ser = open_port()
    ser.write(bytes.fromhex(full_command.replace(' ', '')))
    print(f"Отправлено: {full_command}")   
    
    # Чтение ответа
    time.sleep(0.1)
    response = ser.read(10)
    if response:
        print(f"Получено: {response.hex().upper()}") 
    ser.close()

    send_command('freq_AI_control')
    

if __name__ == "__main__":
    send_command('com_control')
    send_command('start')    # Запуск
    time.sleep(3)
    change_freq(int(input('Частота: ')))  # Установка  Гц
    time.sleep(3)
    read_multiple_params()
    time.sleep(3)
    emergency_stop()
    # send_command('stop')
    time.sleep(3)
    send_command('discret_control')