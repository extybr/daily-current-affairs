import telebot
import requests
from telebot import types
from loguru import logger
from time import sleep

URL = 'https://www.cbr-xml-daily.ru/latest.js'
HEADERS = {'Host': 'https://www.cbr-xml-daily.ru', 'User-Agent': 'Mozilla/5.0', 'Accept': '*/*',
           'Accept-Encoding': 'gzip, deflate, br', 'Connection': 'keep-alive'}

token = 'blablabla'
bot = telebot.TeleBot(token)
bot.remove_webhook()


@bot.message_handler(commands=['start'])
def start(message):
    bot.clear_step_handler(message)
    logger.info(message.chat.id)
    markup = types.ReplyKeyboardMarkup(resize_keyboard=True)
    button_1 = types.KeyboardButton('😄 USD - EUR 😄')
    button_2 = types.KeyboardButton('🐷 Жеребцу 🐷')
    button_3 = types.KeyboardButton('🙏 работа 🙏')
    button_4 = types.KeyboardButton('🚷 stop 🚷')
    markup.row(button_1, button_2, button_3, button_4)
    bot.send_message(message.chat.id, 'Ну что готов к поиску работы?', reply_markup=markup)
    url = 'https://skyteach.ru/wp-content/cache/thumb/d7/81a695a40a5dfd7_730x420.jpg'
    bot.send_photo(message.chat.id, photo=url, reply_markup=markup)


@bot.message_handler(content_types='text')
def message_reply(message):
    logger.info(message.text)
    if message.text == '😄 USD - EUR 😄':
        # bot.send_message(message.chat.id, "https://cbr.ru/key-indicators/")
        try:
            result = requests.get(URL, HEADERS).json()
            result_1 = round(1 / result["rates"]['USD'], 3)
            result_2 = round(1 / result["rates"]['EUR'], 3)
            bot.send_message(message.chat.id, f'USD - {str(result_1)} / EUR - {str(result_2)}')
        except OSError:
            print('Такого пути нет, либо сервер недоступен')
    if message.text == "🐷 Жеребцу 🐷":
        url_img = "https://bestwine24.ru/image/cache/catalog/vodka/" \
                  "eef2e315f762519e75aba64a800b63e9-540x720.jpg"
        bot.send_photo(message.chat.id, photo=url_img)
    if message.text == "🚷 stop 🚷":
        try:
            # bot.stop_polling()
            bot.stop_bot()
        except RuntimeError:
            print('finish')
    if message.text == "🙏 работа 🙏":
        text = "C:\\Users\\Professional\\Desktop\\_vacancies.txt"
        with open(text, 'r', encoding='utf-8') as txt:
            for line in txt.readlines():
                if len(line) < 3:
                    bot.send_message(message.chat.id, '-----')
                else:
                    bot.send_message(message.chat.id, line.strip())
                if line.startswith('🚘'):
                    sleep(5)


while True:
    try:
        bot.polling()
    except BaseException as e:
        print(e)
        sleep(60)

