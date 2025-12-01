import tkinter as tk
from tkinter import ttk
import serial
import time
import threading
import sys
from io import StringIO

# pyinstaller --onefile --windowed --icon=++.ico --name "FrequencyConverter" silium_gui.py
# silium
# hex-code: 01 03 00 00 00 0A C5 CD
#  01 - адрес устройства
#  03 - функция чтения Holding Registers
#  00 00 - начальный адрес
#  00 0A - количество регистров (10)
#  C5 CD - CRC

PORT = 'COM8'  # Настройки порта
BAUDRATE = 9600  # Скорость обмена

# Глобальный флаг для остановки всех операций при закрытии программы
program_running = True

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


class SerialManager:
    """Менеджер для управления последовательным портом"""
    def __init__(self):
        self.ser = None
        self.lock = threading.Lock()
        self.last_operation_time = 0
        self.min_operation_interval = 0.1  # Минимальный интервал между операциями 100ms
        
    def get_connection(self):
        """Получаем соединение с портом"""
        global program_running
        if not program_running:
            return None
            
        with self.lock:
            current_time = time.time()
            # Защита от слишком частых операций
            if current_time - self.last_operation_time < self.min_operation_interval:
                time.sleep(self.min_operation_interval - (current_time - self.last_operation_time))    
            if self.ser is None or not self.ser.is_open:
                try:
                    self.ser = serial.Serial(
                        port=PORT,
                        baudrate=BAUDRATE,
                        bytesize=8,
                        parity='N',
                        stopbits=1,
                        timeout=0.5  # Уменьшил timeout для более быстрой реакции
                    )
                    time.sleep(0.05)  # Короткая пауза после открытия
                except Exception as e:
                    print(f"Ошибка открытия порта {PORT}: {e}")
                    return None
            return self.ser
    
    def execute_command(self, command_bytes, description=""):
        """Выполнение команды с защитой от конфликтов"""
        global program_running
        if not program_running:
            return False    
        ser = self.get_connection()
        if not ser:
            print(f"Ошибка: не удалось открыть порт для команды {description}")
            return False 
        try:
            with self.lock:
                if not program_running:
                    return False
                    
                self.last_operation_time = time.time()
                ser.write(command_bytes)
                print(f"Отправлено: {command_bytes.hex().upper()} - {description}")
                
                # Читаем ответ (если есть)
                time.sleep(0.05)  # Уменьшил задержку
                response = ser.read(10)
                if response:
                    print(f"Получено: {response.hex().upper()}")
                return True
                
        except Exception as e:
            print(f"Ошибка при выполнении команды {description}: {e}")
            # Закрываем проблемное соединение
            self.close_connection()
            return False
    
    def close_connection(self):
        """Закрываем соединение"""
        with self.lock:
            if self.ser and self.ser.is_open:
                self.ser.close()
                self.ser = None


# Глобальный менеджер соединений
serial_manager = SerialManager()


class PrintRedirector:
    def __init__(self, text_widget):
        self.text_widget = text_widget
        
    def write(self, string):
        self.text_widget.insert(tk.END, string)
        self.text_widget.see(tk.END)
        self.text_widget.update_idletasks()
        
    def flush(self):
        pass


def emergency_stop():
    """Аварийная остановка через разные команды"""
    global program_running
    if not program_running:
        return
        
    emergency_commands = [
        '01 06 20 00 00 05 42 09',  # свободный останов
        '01 06 20 00 00 06 02 08',  # останов с замедлением  
    ]
    
    for cmd in emergency_commands:
        if not program_running:
            break
        serial_manager.execute_command(
            bytes.fromhex(cmd), 
            f"Аварийная остановка: {cmd}"
        )
        time.sleep(0.05)  # Короткая пауза между командами


def send_command(cmd_name: str) -> bool:
    """Улучшенная функция отправки команды"""
    global program_running
    if not program_running:
        return False
        
    if cmd_name not in COMMANDS:
        print(f"Ошибка: неизвестная команда {cmd_name}")
        return False
        
    return serial_manager.execute_command(COMMANDS[cmd_name], cmd_name)

        
def read_multiple_params() -> dict:
    global program_running
    params_dict = {}
    
    if not program_running:
        params_dict['error'] = "Программа завершает работу"
        return params_dict
        
    print("=== ЧТЕНИЕ ПАРАМЕТРОВ ЧАСТОТНИКА ===")
    
    params = {
        'frequency': ('1001', 'Текущая частота', 'Гц', 0.01),
        'output_current': ('1004', 'Текущий ток', 'А', 0.1),
        'dc_voltage': ('1002', 'Напряжение шины постоянного тока', 'В', 0.1),
        'output_voltage': ('1003', 'Выходное напряжение', 'В', 1.0),
        'output_power': ('1005', 'Выходная мощность', 'кВт', 0.01),
        'output_torque': ('1006', 'Выходной момент', '%', 1.0),
        'motor_speed': ('1007', 'Скорость двигателя', 'об/мин', 0.3),
        'current_AI1': ('100A', 'Ток/Напряжение AI1', 'В/mA', 0.01),
        'main_display': ('101F', 'Основной дисплей частоты X', 'Гц', 0.01),
        'add_display': ('1020', 'Вспомогательная частота Y', 'Гц', 1.0),
        'freq_display': ('7001', 'Чтение основной дисплей частоты с 7001 регистра', 'Гц', 0.01),
    }
    
    ser = serial_manager.get_connection()
    if not ser:
        params_dict['error'] = "Ошибка связи: не удалось открыть порт"
        return params_dict
    
    try:
        for name, (address_hex, desc, unit, multiplier) in params.items():
            if not program_running:
                break
                
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
            
            # Отправка команды через менеджер
            with serial_manager.lock:
                if not program_running:
                    break
                    
                serial_manager.last_operation_time = time.time()
                ser.write(cmd)
                
                # Чтение ответа
                response = ser.read(7)
                
                if len(response) == 7:
                    # Парсим данные (байты 3-4)
                    raw_value = int.from_bytes(response[3:5], byteorder='big')
                    
                    # ОСОБЕННАЯ ОБРАБОТКА ДЛЯ СКОРОСТИ ДВИГАТЕЛЯ ПРИ РЕВЕРСЕ
                    if name == 'motor_speed':
                        # Проверяем, является ли значение отрицательным (реверс)
                        # В Modbus отрицательные значения представляются как дополнение до 65536
                        if raw_value >= 32768:
                            # Это отрицательное значение - преобразуем
                            raw_value = raw_value - 65536
                        
                        real_value = raw_value * multiplier
                        # Форматируем с учетом знака
                        params_dict[name] = f"{real_value:+.2f} {unit}"
                    else:
                        # Для всех остальных параметров обычное вычисление
                        real_value = raw_value * multiplier
                        params_dict[name] = f"{real_value:.2f} {unit}"
                    
                    print(f"{desc}: {params_dict[name]}")
                else:
                    params_dict[name] = "ОШИБКА ЧТЕНИЯ"
                    print(f"{desc}: ОШИБКА ЧТЕНИЯ")
            
            # Уменьшил паузу между запросами
            if program_running:
                time.sleep(0.1)
        
    except Exception as e:
        print(f"Ошибка связи: {e}")
        params_dict['error'] = f"Ошибка связи: {e}"
        serial_manager.close_connection()
    
    return params_dict


def get_crc(data_hex):
    # Убеждаемся, что строка без пробелов и четной длины
    clean_hex = data_hex.replace(' ', '')
    if len(clean_hex) % 2 != 0:
        clean_hex = '0' + clean_hex
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


def change_freq(freq_hz: float) -> None:
    global program_running
    if not program_running:
        return
        
    if not (0 <= freq_hz <= 50):
        print("Ошибка: частота должна быть от 0 до 50 Гц")
        return

    # Округляем до сотых долей
    freq_hz = round(freq_hz, 2)
    
    # Правильное преобразование: 1 Гц = 200 единиц (0.02 Гц)
    freq_value = int(freq_hz * 200)
    
    # Преобразуем в HEX
    num_hex = f"{freq_value:04X}"
    
    # Формируем команду
    data_for_crc = f"01061000{num_hex}"
    crc = get_crc(data_for_crc)
    
    # Полная команда с пробелами
    full_command = f"01 06 10 00 {num_hex[:2]} {num_hex[2:]} {crc[:2]} {crc[2:]}"
    
    # Отправка через менеджер
    serial_manager.execute_command(
        bytes.fromhex(full_command.replace(' ', '')),
        f"Установка частоты {freq_hz:.2f} Гц"
    )


class FrequencyConverterGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Русолово. Управление частотником")
        self.root.geometry("750x750")
        
        # Переменные
        self.current_freq = tk.DoubleVar(value=0)
        self.is_reading = False
        self.selected_port = tk.StringVar(value='COM8')
        self.button_cooldown = {}
        self.cooldown_time = 0.3
        self.reading_thread = None
        self.operation_threads = []  # Список для отслеживания потоков операций
        
        # Создаем шрифт для параметров
        self.param_font = ('Arial', 10, 'bold')
        
        # Создаем notebook для вкладок
        self.notebook = ttk.Notebook(root)
        self.notebook.pack(fill='both', expand=True, padx=10, pady=10)
        
        # Создаем вкладки
        self.create_main_tab()
        self.create_settings_tab()
        
        # Перенаправляем вывод в консоль на вторую вкладку
        self.redirect_stdout()
        
        # Закрываем соединение при выходе
        self.root.protocol("WM_DELETE_WINDOW", self.on_close)
        
    def on_close(self):
        """Закрытие соединения при выходе из программы"""
        global program_running
        
        # Устанавливаем флаг остановки для всех операций
        program_running = False
        
        # Останавливаем чтение параметров
        self.stop_reading_params()
        
        # Останавливаем все потоки операций
        self.stop_all_operations()
        
        # Даем время всем операциям завершиться
        time.sleep(0.3)
        
        # Закрываем соединение
        serial_manager.close_connection()
        
        # Уничтожаем окно
        self.root.destroy()
        
    def stop_all_operations(self):
        """Остановка всех активных потоков операций"""
        for thread in self.operation_threads[:]:
            if thread.is_alive():
                thread.join(timeout=1.0)  # Ждем завершения потока максимум 1 секунду
        
    def cleanup_completed_threads(self):
        """Очистка завершенных потоков из списка"""
        self.operation_threads = [thread for thread in self.operation_threads if thread.is_alive()]
        
    def start_threaded_operation(self, target_func, *args):
        """Запуск операции в отдельном потоке с контролем"""
        global program_running
        if not program_running:
            return
            
        # Очищаем завершенные потоки
        self.cleanup_completed_threads()
        
        # Создаем и запускаем поток
        thread = threading.Thread(target=target_func, args=args, daemon=True)
        thread.start()
        self.operation_threads.append(thread)
        
    def redirect_stdout(self):
        """Перенаправляем stdout в текстовое поле на вкладке настроек"""
        self.print_redirector = PrintRedirector(self.console_text)
        sys.stdout = self.print_redirector
        
    def safe_button_action(self, button_name, action_func, *args):
        """Защита от быстрых повторных нажатий кнопок"""
        global program_running
        if not program_running:
            return
            
        current_time = time.time()
        last_press = self.button_cooldown.get(button_name, 0)
        
        if current_time - last_press < self.cooldown_time:
            return
            
        self.button_cooldown[button_name] = current_time
        action_func(*args)

    # ОСНОВНЫЕ КОМАНДЫ ЧАСТОТНИКА - ВСЕ В ОТДЕЛЬНЫХ ПОТОКАХ
    def start_converter(self):
        self.log_message("Запуск частотника...")
        self.start_threaded_operation(self._start_converter_thread)

    def _start_converter_thread(self):
        send_command('start')

    def revers_converter(self):
        self.log_message("Реверсивный запуск частотника...")
        self.start_threaded_operation(self._revers_converter_thread)
        
    def _revers_converter_thread(self):
        send_command('revers')
        
    def stop_converter(self):
        self.log_message("Остановка частотника...")
        self.start_threaded_operation(self._stop_converter_thread)
        
    def _stop_converter_thread(self):
        send_command('stop')
        
    def emergency_stop(self):
        self.log_message("АВАРИЙНАЯ ОСТАНОВКА!")
        self.start_threaded_operation(self._emergency_stop_thread)
        
    def _emergency_stop_thread(self):
        emergency_stop()
        
    def com_control(self):
        self.log_message("Установка COM Control...")
        self.start_threaded_operation(self._com_control_thread)
        
    def _com_control_thread(self):
        send_command('com_control')
        
    def discret_control(self):
        self.log_message("Установка Discret Control...")
        self.start_threaded_operation(self._discret_control_thread)
        
    def _discret_control_thread(self):
        send_command('discret_control')
        
    def freq_com_control(self):
        self.log_message("Установка Freq COM Control...")
        self.start_threaded_operation(self._freq_com_control_thread)
        
    def _freq_com_control_thread(self):
        send_command('freq_com_control')
        
    def freq_ai_control(self):
        self.log_message("Установка Freq AI Control...")
        self.start_threaded_operation(self._freq_ai_control_thread)
        
    def _freq_ai_control_thread(self):
        send_command('freq_AI_control')
        
    def on_freq_change(self, value):
        # Обновление значения частоты при движении слайдера
        freq_value = round(float(value), 2)
        self.current_freq.set(freq_value)
        
    def apply_frequency(self):
        try:
            freq = round(float(self.current_freq.get()), 2)
            if 0 <= freq <= 50:
                self.log_message(f"Установка частоты: {freq:.2f} Гц")
                self.start_threaded_operation(self._apply_frequency_thread, freq)
            else:
                self.log_message("Ошибка: частота должна быть от 0 до 50 Гц")
        except ValueError:
            self.log_message("Ошибка: введите корректное число для частоты")
    
    def _apply_frequency_thread(self, freq):
        change_freq(freq)
        
    def start_reading_params(self):
        """Запуск циклического чтения параметров"""
        if self.is_reading:
            self.log_message("Чтение параметров уже запущено")
            return
            
        self.is_reading = True
        self.log_message("Запуск циклического чтения параметров...")
        self.reading_thread = threading.Thread(target=self.read_params_loop, daemon=True)
        self.reading_thread.start()
        
    def stop_reading_params(self):
        """Остановка чтения параметров"""
        if not self.is_reading:
            return
            
        self.is_reading = False
        self.log_message("Остановка чтения параметров...")
        
    def read_params_loop(self):
        """Цикл чтения параметров с проверкой флага остановки"""
        while self.is_reading and program_running:
            try:
                params = read_multiple_params()
                # Обновляем GUI в основном потоке
                self.root.after(0, self.update_params_display, params)
                
                # Разбиваем sleep на короткие интервалы для быстрой реакции на остановку
                for i in range(10):
                    if not self.is_reading or not program_running:
                        break
                    time.sleep(0.1)
                    
            except Exception as e:
                if self.is_reading and program_running:
                    print(f"Ошибка в цикле чтения: {e}")
            
    def update_params_display(self, params):
        """Обновление отображения параметров (вызывается в основном потоке)"""
        # Обновление левой колонки
        for param_id, label in self.params_labels_left.items():
            if param_id in params:
                label.config(text=params[param_id])
        
        # Обновление правой колонки
        for param_id, label in self.params_labels_right.items():
            if param_id in params:
                label.config(text=params[param_id])
        
    def create_main_tab(self):
        # Основная вкладка
        self.main_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.main_tab, text="Управление")
        
        # Основной фрейм
        main_frame = ttk.Frame(self.main_tab, padding="10")
        main_frame.pack(fill='both', expand=True)
        
        # Кнопки управления
        control_frame = ttk.LabelFrame(main_frame, text="Управление", padding="10")
        control_frame.pack(fill='x', pady=5)
        
        # Левая группа кнопок управления
        left_control_frame = ttk.Frame(control_frame)
        left_control_frame.pack(side='left', anchor='w')
        
        # Кнопки с защитой от быстрых нажатий
        ttk.Button(left_control_frame, text="Пуск", 
                  command=lambda: self.safe_button_action("start", self.start_converter)).grid(row=0, column=0, padx=5)
        ttk.Button(left_control_frame, text="Реверс", 
                  command=lambda: self.safe_button_action("revers", self.revers_converter)).grid(row=0, column=1, padx=5)
        ttk.Button(left_control_frame, text="Стоп", 
                  command=lambda: self.safe_button_action("stop", self.stop_converter)).grid(row=0, column=2, padx=5)
        ttk.Button(left_control_frame, text="Аварийный стоп", 
                  command=lambda: self.safe_button_action("emergency", self.emergency_stop)).grid(row=0, column=3, padx=5)
        
        # Правая группа кнопок управления
        right_control_frame = ttk.Frame(control_frame)
        right_control_frame.pack(side='right', anchor='e')
        
        ttk.Button(right_control_frame, text="Читать параметры", 
                  command=lambda: self.safe_button_action("read_start", self.start_reading_params)).grid(row=0, column=0, padx=5)
        ttk.Button(right_control_frame, text="Остановить чтение", 
                  command=lambda: self.safe_button_action("read_stop", self.stop_reading_params)).grid(row=0, column=1, padx=5)
        
        # Кнопки управления режимами частотника
        mode_frame = ttk.LabelFrame(main_frame, text="Управление режимами частотника", padding="10")
        mode_frame.pack(fill='x', pady=5)
        
        # Левая группа кнопок режимов
        left_mode_frame = ttk.Frame(mode_frame)
        left_mode_frame.pack(side='left', anchor='w')
        
        ttk.Button(left_mode_frame, text="COM Control", 
                  command=lambda: self.safe_button_action("com_control", self.com_control)).grid(row=0, column=0, padx=5)
        ttk.Button(left_mode_frame, text="Discret Control", 
                  command=lambda: self.safe_button_action("discret_control", self.discret_control)).grid(row=0, column=1, padx=5)
        
        # Правая группа кнопок режимов
        right_mode_frame = ttk.Frame(mode_frame)
        right_mode_frame.pack(side='right', anchor='e')
        
        ttk.Button(right_mode_frame, text="Freq COM Control", 
                  command=lambda: self.safe_button_action("freq_com", self.freq_com_control)).grid(row=0, column=0, padx=5)
        ttk.Button(right_mode_frame, text="Freq AI Control", 
                  command=lambda: self.safe_button_action("freq_ai", self.freq_ai_control)).grid(row=0, column=1, padx=5)
        
        # Слайдер для частоты
        freq_frame = ttk.LabelFrame(main_frame, text="Установка частоты", padding="10")
        freq_frame.pack(fill='x', pady=5)
        
        ttk.Label(freq_frame, text="Частота (Гц):").grid(row=0, column=0)
        self.freq_scale = ttk.Scale(freq_frame, from_=0, to=50, orient=tk.HORIZONTAL, 
                                   variable=self.current_freq, command=self.on_freq_change)
        self.freq_scale.grid(row=0, column=1, sticky='ew', padx=10)
        
        # Поле для точного ввода частоты
        self.freq_entry = ttk.Entry(freq_frame, width=8, textvariable=self.current_freq)
        self.freq_entry.grid(row=0, column=2, padx=5)
        self.freq_entry.bind('<Return>', lambda e: self.safe_button_action("apply_freq", self.apply_frequency))
        
        ttk.Button(freq_frame, text="Применить", 
                  command=lambda: self.safe_button_action("apply_freq", self.apply_frequency)).grid(row=0, column=3, padx=5)
        freq_frame.columnconfigure(1, weight=1)
        
        # Параметры с увеличенным шрифтом
        params_frame = ttk.LabelFrame(main_frame, text="Параметры частотника", padding="10")
        params_frame.pack(fill='both', expand=True, pady=5)
        
        # Левая колонка параметров
        self.params_labels_left = {}
        params_left = [
            ('frequency', 'Частота:'),
            ('output_current', 'Ток:'),
            ('dc_voltage', 'Напряжение DC:'),
            ('output_voltage', 'Выходное напряжение:'),
            ('output_power', 'Выходная мощность:'),
            ('output_torque', 'Выходной момент:')
        ]
        
        for i, (param_id, param_name) in enumerate(params_left):
            ttk.Label(params_frame, text=param_name).grid(row=i, column=0, sticky=tk.W, pady=2)
            self.params_labels_left[param_id] = ttk.Label(params_frame, text="---", font=self.param_font)
            self.params_labels_left[param_id].grid(row=i, column=1, sticky=tk.W, pady=2, padx=(10, 20))
        
        # Правая колонка параметров
        self.params_labels_right = {}
        params_right = [
            ('motor_speed', 'Скорость двигателя:'),
            ('current_AI1', 'Ток/Напряжение AI1:'),
            ('main_display', 'Основной дисплей:'),
            ('add_display', 'Вспомогательная частота:'),
            ('freq_display', 'Дисплей частоты 7001:')
        ]
        
        for i, (param_id, param_name) in enumerate(params_right):
            ttk.Label(params_frame, text=param_name).grid(row=i, column=2, sticky=tk.W, pady=2)
            self.params_labels_right[param_id] = ttk.Label(params_frame, text="---", font=self.param_font)
            self.params_labels_right[param_id].grid(row=i, column=3, sticky=tk.W, pady=2, padx=(10, 0))
        
        # Настройка весов для параметров
        params_frame.columnconfigure(1, weight=1)
        params_frame.columnconfigure(3, weight=1)
        
        # ЛОГИ НА ГЛАВНОЙ ВКЛАДКЕ
        log_frame = ttk.LabelFrame(main_frame, text="Логи операций", padding="10")
        log_frame.pack(fill='both', expand=True, pady=5)
        
        self.main_log_text = tk.Text(log_frame, height=6, width=70, wrap='word')
        main_log_scrollbar = ttk.Scrollbar(log_frame, orient='vertical', command=self.main_log_text.yview)
        self.main_log_text.configure(yscrollcommand=main_log_scrollbar.set)
        
        self.main_log_text.pack(side='left', fill='both', expand=True)
        main_log_scrollbar.pack(side='right', fill='y')
        
    def create_settings_tab(self):
        # Вкладка настроек
        self.settings_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.settings_tab, text="Настройки и логи")
        
        # Создаем основной контейнер с правильным распределением весов
        main_container = ttk.Frame(self.settings_tab)
        main_container.pack(fill='both', expand=True)
        
        # Верхняя часть - настройки портов
        top_frame = ttk.Frame(main_container)
        top_frame.pack(fill='x', pady=5)
        
        # Выбор COM-порта
        port_frame = ttk.LabelFrame(top_frame, text="Выбор COM-порта", padding="10")
        port_frame.pack(fill='x', padx=10, pady=5)
        
        ttk.Label(port_frame, text="Выберите COM-порт:").pack(anchor='w', pady=5)
        
        # Создаем фрейм для чекбоксов
        ports_frame = ttk.Frame(port_frame)
        ports_frame.pack(fill='x', pady=5)
        
        # Создаем чекбоксы для COM-портов от 1 до 20 - ПО 10 В РЯДУ
        self.port_vars = {}
        for i in range(1, 21):
            port_name = f'COM{i}'
            var = tk.BooleanVar(value=(port_name == 'COM8'))
            self.port_vars[port_name] = var
            
            cb = ttk.Checkbutton(ports_frame, text=port_name, variable=var, 
                               command=lambda p=port_name: self.on_port_select(p))
            # Располагаем по 10 в ряду с меньшими отступами
            cb.grid(row=(i-1)//10, column=(i-1)%10, sticky='w', padx=3, pady=1)
        
        # Кнопка применения порта
        ttk.Button(port_frame, text="Применить выбранный порт", 
                  command=self.apply_selected_port).pack(anchor='w', pady=10)
        
        # Текущий выбранный порт
        self.current_port_label = ttk.Label(port_frame, text=f"Текущий порт: {self.selected_port.get()}", 
                                          font=('Arial', 10, 'bold'))
        self.current_port_label.pack(anchor='w', pady=5)
        
        # Нижняя часть - консоль вывода (ЗАНИМАЕТ ВСЕ ОСТАВШЕЕСЯ МЕСТО)
        bottom_frame = ttk.Frame(main_container)
        bottom_frame.pack(fill='both', expand=True, pady=5)
        
        # Консоль вывода
        console_frame = ttk.LabelFrame(bottom_frame, text="Полная консоль вывода", padding="10")
        console_frame.pack(fill='both', expand=True, padx=10, pady=5)
        
        # Текстовое поле для консоли
        self.console_text = tk.Text(console_frame, wrap='word')
        console_scrollbar = ttk.Scrollbar(console_frame, orient='vertical', command=self.console_text.yview)
        self.console_text.configure(yscrollcommand=console_scrollbar.set)
        
        self.console_text.pack(side='left', fill='both', expand=True)
        console_scrollbar.pack(side='right', fill='y')
        
        # Кнопка очистки консоли
        console_buttons_frame = ttk.Frame(bottom_frame)
        console_buttons_frame.pack(fill='x', padx=10, pady=5)
        
        ttk.Button(console_buttons_frame, text="Очистить консоль", 
                  command=self.clear_console).pack(side='left', padx=5)
        
        # Настройка весов для правильного распределения пространства
        main_container.rowconfigure(1, weight=1)
        bottom_frame.rowconfigure(0, weight=1)
        console_frame.rowconfigure(0, weight=1)
        
    def on_port_select(self, port_name):
        """Обработчик выбора порта"""
        for port, var in self.port_vars.items():
            if port != port_name:
                var.set(False)
        self.selected_port.set(port_name)
        self.current_port_label.config(text=f"Текущий порт: {port_name}")
        
    def apply_selected_port(self):
        """Применение выбранного порта"""
        global PORT
        PORT = self.selected_port.get()
        # Закрываем старое соединение при смене порта
        serial_manager.close_connection()
        print(f"COM-порт изменен на: {PORT}")
        
    def clear_console(self):
        """Очистка консоли"""
        self.console_text.delete(1.0, tk.END)
        
    def log_message(self, message):
        """Логирование сообщений в основное поле логов и консоль"""
        print(message)
        self.main_log_text.insert(tk.END, f"{message}\n")
        self.main_log_text.see(tk.END)
        self.main_log_text.update_idletasks()
        
    def start_converter(self):
        self.log_message("Запуск частотника...")
        threading.Thread(target=lambda: send_command('start'), daemon=True).start()

    def revers_converter(self):
        self.log_message("Реверсивный запуск частотника...")
        threading.Thread(target=lambda: send_command('revers'), daemon=True).start()
        
    def stop_converter(self):
        self.log_message("Остановка частотника...")
        threading.Thread(target=lambda: send_command('stop'), daemon=True).start()
        
    def emergency_stop(self):
        self.log_message("АВАРИЙНАЯ ОСТАНОВКА!")
        threading.Thread(target=emergency_stop, daemon=True).start()
        
    def com_control(self):
        self.log_message("Установка COM Control...")
        threading.Thread(target=lambda: send_command('com_control'), daemon=True).start()
        
    def discret_control(self):
        self.log_message("Установка Discret Control...")
        threading.Thread(target=lambda: send_command('discret_control'), daemon=True).start()
        
    def freq_com_control(self):
        self.log_message("Установка Freq COM Control...")
        threading.Thread(target=lambda: send_command('freq_com_control'), daemon=True).start()
        
    def freq_ai_control(self):
        self.log_message("Установка Freq AI Control...")
        threading.Thread(target=lambda: send_command('freq_AI_control'), daemon=True).start()
        
    def on_freq_change(self, value):
        # Обновление значения частоты при движении слайдера - ТОЧНОЕ ОТОБРАЖЕНИЕ ДО СОТЫХ
        freq_value = round(float(value), 2)
        self.current_freq.set(freq_value)
        
    def apply_frequency(self):
        try:
            freq = round(float(self.current_freq.get()), 2)
            if 0 <= freq <= 50:
                self.log_message(f"Установка частоты: {freq:.2f} Гц")
                threading.Thread(target=lambda: change_freq(freq), daemon=True).start()
            else:
                self.log_message("Ошибка: частота должна быть от 0 до 50 Гц")
        except ValueError:
            self.log_message("Ошибка: введите корректное число для частоты")
        
    def start_reading_params(self):
        """Запуск циклического чтения параметров"""
        if self.is_reading:
            self.log_message("Чтение параметров уже запущено")
            return
            
        self.is_reading = True
        self.log_message("Запуск циклического чтения параметров...")
        self.reading_thread = threading.Thread(target=self.read_params_loop, daemon=True)
        self.reading_thread.start()
        
    def stop_reading_params(self):
        """Остановка чтения параметров"""
        if not self.is_reading:
            return
            
        self.is_reading = False
        self.log_message("Остановка чтения параметров...")
        
    def read_params_loop(self):
        """Цикл чтения параметров с проверкой флага остановки"""
        while self.is_reading and program_running:
            try:
                params = read_multiple_params()
                self.update_params_display(params)
                
                # Разбиваем sleep на короткие интервалы для быстрой реакции на остановку
                for i in range(10):
                    if not self.is_reading or not program_running:
                        break
                    time.sleep(0.1)
                    
            except Exception as e:
                # Логируем ошибки только если чтение не остановлено
                if self.is_reading and program_running:
                    print(f"Ошибка в цикле чтения: {e}")
            
    def update_params_display(self, params):
        # Обновление левой колонки
        for param_id, label in self.params_labels_left.items():
            if param_id in params:
                label.config(text=params[param_id])
        
        # Обновление правой колонки
        for param_id, label in self.params_labels_right.items():
            if param_id in params:
                label.config(text=params[param_id])


if __name__ == "__main__":
    root = tk.Tk()
    app = FrequencyConverterGUI(root)
    root.mainloop()