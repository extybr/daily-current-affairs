import telebot
from telebot import types
import pymysql.cursors

TOKEN = "TOKEN"
DB = 'data_base'
PASS = 'PASS'
bot = telebot.TeleBot(TOKEN)
MYSQL_CONNECTION = pymysql.connect(host='localhost',
                                   user='root',
                                   password=PASS,
                                   db=DB,
                                   charset='utf8mb4',
                                   cursorclass=pymysql.cursors.DictCursor)


def init_mysql():
    conn = pymysql.connect(host='localhost', user='root', password=PASS,
                           cursorclass=pymysql.cursors.DictCursor)
    try:
        with conn.cursor() as cursor:
            cursor.execute(f'CREATE SCHEMA IF NOT EXISTS {DB}')
            conn.commit()
    except BaseException as error:
        print(error)
    finally:
        conn.close()

    connection = MYSQL_CONNECTION
    try:
        with connection.cursor() as cursor:
            cursor.execute('''CREATE TABLE test (user_id integer, user_name text,
            user_surname text, username text)''')
            connection.commit()
    except BaseException as error:
        print(error)
    finally:
        connection.close()


def db_table_val(user_id: int, user_name: str, user_surname: str, username: str):
    connection = MYSQL_CONNECTION
    try:
        with connection.cursor() as cursor:
            cursor.execute('INSERT INTO test (user_id, user_name, user_surname, username)'
                           ' VALUES (%s,%s,%s,%s)', (user_id, user_name, user_surname, username))
            connection.commit()
    except BaseException as error:
        print(error)
    finally:
        connection.close()


def db_table_read(user_name: str):
    connection = MYSQL_CONNECTION
    try:
        with connection.cursor() as cursor:
            cursor.execute(f'SELECT * FROM test WHERE user_name = "{user_name}"')
            for row in cursor:
                yield row
    except BaseException as error:
        print(error)
    finally:
        connection.close()


def db_table_del(user_name: str):
    connection = MYSQL_CONNECTION
    try:
        with connection.cursor() as cursor:
            cursor.execute(f'DELETE FROM test WHERE user_name = "{user_name}"')
            connection.commit()
    except BaseException as error:
        print(error)
    finally:
        connection.close()


@bot.message_handler(commands=['start'])
def start_message(message):
    markup = types.ReplyKeyboardMarkup(resize_keyboard=True)
    bot.clear_step_handler(message)
    button_1 = types.KeyboardButton('😎 read db 😎')
    markup.row(button_1)
    bot.send_message(message.chat.id, 'Добро пожаловать', reply_markup=markup)


@bot.message_handler(content_types=['text'])
def get_text_messages(message):
    user_id = message.from_user.id
    user_name = message.from_user.first_name
    user_surname = message.from_user.last_name
    username = message.from_user.username
    if message.text == '😎 read db 😎':
        db_table_val(user_id, user_name, user_surname, username)
        # db_table_del(user_name)
        [bot.send_message(message.from_user.id, f'{i} 😜') for i in db_table_read(user_name)]
    else:
        bot.send_message(message.from_user.id, 'Включаю запись 😄')


try:
    mysql_conn = MYSQL_CONNECTION
    if mysql_conn.open:
        mysql_conn.close()
except pymysql.err.OperationalError as er:
    if str(er).find('Unknown database'):
        init_mysql()

bot.polling(none_stop=True)
