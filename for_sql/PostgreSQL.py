from loguru import logger
from psycopg2 import connect
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import json
import os
from dotenv import load_dotenv

load_dotenv()
PASS = os.getenv("PASS")


def init_db():
    connection = connect(user="postgres", password=PASS,
                         host="localhost", port="5432")
    connection.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    with connection.cursor() as cursor:
        cursor.execute("create database hotels_db")
        connection.commit()

    connection = connect(user="postgres", password=PASS,
                         host="localhost", port="5432", dbname='hotels_db')
    with connection.cursor() as cursor:
        cursor.execute("CREATE TABLE users (id serial primary key not null, user_id integer,"
                       " user_name text, user_surname text, username text)")
        connection.commit()


def db_table_delete(user_id: int):
    connection = connect(user="postgres", password=PASS,
                         host="localhost", port="5432", dbname='hotels_db')
    connection.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    with connection.cursor() as cursor:
        command = "DELETE FROM users WHERE user_id = {}".format(user_id)
        cursor.execute(command)


def db_table_insert(user_id: int, user_name: str, user_surname: str, username: str):
    connection = connect(user="postgres", password=PASS,
                         host="localhost", port="5432", dbname='hotels_db')
    connection.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    with connection.cursor() as cursor:
        cursor.execute("INSERT INTO users (user_id, user_name, user_surname, username)"
                       " VALUES (%s,%s,%s,%s)", (user_id, user_name, user_surname, username))


def db_table_read(user_id: int):
    connection, cursor = None, None
    try:
        connection = connect(user="postgres", password=PASS,
                             host="localhost", port="5432", dbname='hotels_db')
        connection.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        with connection.cursor() as cursor:
            cursor = connection.cursor()
            cursor.execute(f"SELECT * FROM users WHERE user_id = {user_id}")
            for row in cursor:
                yield row
    except Exception as error:
        logger.error("Ошибка при работе с PostgreSQL", error)
    finally:
        if connection:
            cursor.close()
            connection.close()


def db_start():
    try:
        connection = connect(user="postgres", password=PASS,
                             host="localhost", port="5432", dbname='hotels_db')
        if connection:
            cursor = connection.cursor()
            cursor.execute("SELECT version()")
            record = cursor.fetchone()
            info = json.dumps(connection.get_dsn_parameters(), indent=4)
            logger.info(f"Соединение с базой данных PostgreSQL прошло успешно\n"
                        f"Информация о сервере PostgreSQL\n{info}\nВы подключены к - {record}\n")
            connection.close()
            # cursor.execute("show data_directory;")
    except Exception as error:
        logger.error(error)
        logger.info('База данных отсутствует и будет создана')
        init_db()



