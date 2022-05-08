import os.path
import sqlite3
import telebot
from telebot import types

TOKEN = "TOKEN"
DB = 'database.db'
bot = telebot.TeleBot(TOKEN)
CONNECTION = sqlite3.connect(DB, check_same_thread=False)


def init_sqlite():
    conn = CONNECTION
    cursor = conn.cursor()
    cursor.execute('''CREATE TABLE test (id integer primary key, user_id integer, user_name text, 
        user_surname text, username string)''')
    conn.commit()
    conn.close()


def db_read():
    db = 'base.db'
    conn = sqlite3.connect(db, check_same_thread=False)
    cursor = conn.cursor()
    info = cursor.execute(f'SELECT * FROM test WHERE from_salary > 40000 and to_salary > 40000')
    for i in info:
        yield i


def db_table_val(user_id: int, user_name: str, user_surname: str, username: str):
    conn = CONNECTION
    cursor = conn.cursor()
    cursor.execute(
        'INSERT INTO test (user_id, user_name, user_surname, username) VALUES (?, ?, ?, ?)',
        (user_id, user_name, user_surname, username))
    conn.commit()
    conn.close()


def db_table_del(user_id: int):
    conn = CONNECTION
    cursor = conn.cursor()
    command = 'DELETE FROM test WHERE user_id = "{}"'.format(user_id)
    cursor.execute(command)
    conn.commit()
    conn.close()


def db_table_read(user_id: int):
    conn = CONNECTION
    cursor = conn.cursor()
    info = cursor.execute(f'SELECT * FROM test WHERE user_id = "{user_id}"')
    return info.fetchone()


@bot.message_handler(commands=['start'])
def start_message(message):
    markup = types.ReplyKeyboardMarkup(resize_keyboard=True)
    bot.clear_step_handler(message)
    button_1 = types.KeyboardButton('💲 add 💲')
    button_2 = types.KeyboardButton('😎 del 😎')
    button_3 = types.KeyboardButton('🌼 read 🌼')
    button_4 = types.KeyboardButton('😎 read db 😎')
    markup.row(button_1, button_2, button_3, button_4)
    bot.send_message(message.chat.id, 'Добро пожаловать', reply_markup=markup)


@bot.message_handler(content_types=['text'])
def get_text_messages(message):
    us_id = message.from_user.id
    us_name = message.from_user.first_name
    us_sname = message.from_user.last_name
    username = message.from_user.username
    if message.text == '💲 add 💲':
        bot.send_message(message.chat.id, f'{us_name}, ваше имя добавлено в базу данных! 😜')
        db_table_val(user_id=us_id, user_name=us_name, user_surname=us_sname, username=username)
    elif message.text == '😎 del 😎':
        bot.send_message(message.chat.id, f'{us_name}, ваше имя удалено из базы данных! 😜')
        db_table_del(user_id=us_id,)
    elif message.text == '😎 read db 😎':
        [bot.send_message(message.chat.id, f'{i} 😜') for i in db_read()]
    elif message.text == '🌼 read 🌼':
        bot.send_message(message.chat.id, f'{us_name}, передаю данные из базы данных! 😜')
        data = db_table_read(user_id=us_id,)
        if data:
            bot.send_message(message.chat.id, f'id: {data[0]}, user_id: {data[1]}, user_name: '
                                              f'{data[2]}, user_surname: {data[3]}, username:'
                                              f' {data[4]}')
        else:
            bot.send_message(message.chat.id, 'Пусто 😜')
    else:
        bot.send_message(message.from_user.id, 'Включаю запись 😄')


if not [i for i in os.listdir('./') if i == DB]:
    print('База данных отсутствует и будет создана')
    init_sqlite()

bot.polling(none_stop=True)
