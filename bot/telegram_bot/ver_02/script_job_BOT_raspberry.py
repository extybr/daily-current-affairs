﻿from time import sleep
import requests
import telebot
from loguru import logger
from telebot import types
from script_job_led_raspberry import extract_jobs, lamp

URL = 'https://www.cbr-xml-daily.ru/latest.js'
HEADERS = {'Host': 'https://www.cbr-xml-daily.ru', 'User-Agent': 'Mozilla/5.0', 'Accept': '*/*',
           'Accept-Encoding': 'gzip, deflate, br', 'Connection': 'keep-alive'}

token = 'bla-bla-bla'  # полученный токен бота
bot = telebot.TeleBot(token)
bot.remove_webhook()
# (332458533, 558054155) id telegram ниже в коде изменены
USER_1 = 332458533
USER_2 = 558054155


@bot.message_handler(commands=['start'])
def start(message) -> None:
    """ Функция вывода при старте: определение кнопок, приветствие """
    bot.clear_step_handler(message)
    logger.info(message.chat.id)
    markup = types.ReplyKeyboardMarkup(resize_keyboard=True)
    button_1 = types.KeyboardButton('😄 USD - EUR 😄')
    button_2 = types.KeyboardButton('🐷 Жеребцу 🐷')
    button_3 = types.KeyboardButton('🙏 работа 🙏')
    button_4 = types.KeyboardButton('🚷 stop 🚷')
    button_5 = types.KeyboardButton('🌼 read file 🌼')
    button_6 = types.KeyboardButton('🌼 led 🌼')
    button_7 = types.KeyboardButton('🌼 id 🌼')
    markup.row(button_1, button_2, button_3, button_7)
    markup.row(button_5, button_6, button_4)
    bot.send_message(message.chat.id, 'Ну что готов к поиску работы?', reply_markup=markup)
    url = 'https://skyteach.ru/wp-content/cache/thumb/d7/81a695a40a5dfd7_730x420.jpg'
    bot.send_photo(message.chat.id, photo=url, reply_markup=markup)


@bot.message_handler(content_types='text')
def message_reply(message) -> None:
    """
    Функция, обрабатывает нажатие кнопок бота
    Логирование в терминал
    Парсит курсы валют
    Запуск по условию: включение светодиода (реле), парсера вакансий, остановка бота
    """
    logger.info(message.text)
    if message.text == '😄 USD - EUR 😄':
        try:
            result = requests.get(URL, HEADERS).json()
            result_1 = round(1 / result["rates"]['USD'], 3)
            result_2 = round(1 / result["rates"]['EUR'], 3)
            bot.send_message(message.chat.id, f'USD - {str(result_1)} / EUR - {str(result_2)}')
        except OSError:
            print('Сервер недоступен')
            bot.send_message(message.chat.id, 'Сервер недоступен')
    if message.text == "🐷 Жеребцу 🐷":
        url_img = ("https://bestwine24.ru/image/cache/catalog/vodka"
                   "/eef2e315f762519e75aba64a800b63e9-540x720.jpg")
        bot.send_photo(message.chat.id, photo=url_img)
    if message.text == "🌼 read file 🌼":
        if message.chat.id in (USER_1, USER_2):
            send_vacancies(message)
        else:
            bot.send_message(message.chat.id, 'Вам запрещено читать локальный файл 😄')
    if message.text == "🌼 led 🌼":
        if message.chat.id == USER_2:
            lamp()
        else:
            bot.send_message(message.chat.id, 'Вам запрещено включать чайник 😄')
    if message.text == "🌼 id 🌼":
        bot.send_message(message.chat.id, f'{message.chat.id}')
    if message.text == "🚷 stop 🚷":
        if message.chat.id == USER_1:
            try:
                bot.stop_bot()
            except RuntimeError:
                print('finish')
        else:
            bot.send_message(message.chat.id, 'Вам запрещено выключать бота 😄')
    text = '_vacancies.txt'  # путь к файлу и имя файла
    if message.text == "🙏 работа 🙏":
        extract_jobs()
        count = 0
        with open(text, 'r', encoding='utf-8') as txt:
            count += int(txt.readline().strip()[20:])
        if count > 10:
            send_vacancies(message)
        else:
            with open(text, 'r', encoding='utf-8') as txt:
                bot.send_message(message.chat.id, f'{txt.read()}')


def send_vacancies(message) -> None:
    """ Читает локальный файл с вакансиями """
    text = '_vacancies.txt'  # путь к файлу и имя файла
    count = 0
    with open(text, 'r', encoding='utf-8') as txt:
        count += int(txt.readline().strip()[20:])
    bot.send_message(message.chat.id, f'Число вакансий за сутки: {count}')
    if count > 0:
        with open(text, 'r', encoding='utf-8') as txt:
            for i, line in enumerate(txt.readlines()):
                if len(line) < 3:
                    continue
                elif line.count('*') > 5:
                    bot.send_message(message.chat.id, line.strip())
                elif line.find('https://') != -1:
                    bot.send_message(message.chat.id, line.strip())
                elif line.startswith('🚘'):
                    sleep(5)


if __name__ == '__main__':
    while True:
        try:
            bot.polling()
        except BaseException as error:
            print(error)
            sleep(60)
