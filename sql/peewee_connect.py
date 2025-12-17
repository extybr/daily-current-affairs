import functools
from peewee_model import *
from loguru import logger
from typing import Callable
# TODO: Функции работы ОРМ peewee с базой PostgreSQL


def errors(function) -> Callable:
    """
    Функция обработчик ошибок ОРМ базы данных
    :param function: Callable
    :return: Callable
    """
    @functools.wraps(function)
    def wrapper(*args, **kwargs):
        try:
            result = function(*args, **kwargs)
            return result
        except Exception as error:
            logger.error(error)
    return wrapper


@errors
def db_table_read(user_id: int) -> any:
    """
    Функция чтения данных из базы данных
    :param user_id: int
    :return: any
    """
    with db:
        user = Users.get(Users.user_id == user_id)
        # for row in Users.select().where(Users.user_id == user_id):
        #     print(row.user_id, row.user_name, row.user_surname, row.username)
        return user.user_id, user.user_name, user.user_surname, user.username


@errors
def db_table_delete(user_id: int) -> None:
    """
    Функция удаления данных из базы данных
    :param user_id: int
    :return: None
    """
    with db:
        Users.delete().where(Users.user_id == user_id).execute()
        # delete = Users.get(Users.user_id == user_id)
        # delete.delete_instance()


@errors
def db_table_insert(user_id: int, user_name: str, user_surname: str, username: str) -> None:
    """
    Функция добавления данных в базу данных
    :param user_id: int
    :param user_name: str
    :param user_surname: str
    :param username: str
    :return: None
    """
    with db:
        Users.insert(user_id=user_id, user_name=user_name, user_surname=user_surname,
                     username=username).execute()


@errors
def init_db() -> None:
    """
    Функция выполняется один раз для создания базы данных PostgreSQL
    :return: None
    """
    from psycopg2 import connect
    from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
    connection = connect(user="postgres", password=DB_PASSWORD, host="localhost", port="5432")
    connection.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    with connection.cursor() as cursor:  # создаю базу данных в PostgreSQL через psycopg2
        cursor.execute(f"create database {db.database}")
        connection.commit()
        cursor.close()
        connection.close()
        logger.info(f"Создана база данных {db.database}")
    with db:  # создаю таблицу в базе через ОРМ peewee
        Users.create_table("users (user_id integer not null, user_name text, user_surname text,"
                           " username text)")
        logger.info('Создана таблица в базе данных')


def db_start() -> None:
    """
    Функция инициализации базы данных
    :return: None
    """
    try:
        with db:  # проверяю есть ли связь с базой данных, если базы нет, создаю ее
            logger.success(f'Связь с базой <{db.database}> установлена')
    except Exception as error:
        logger.warning(f'{error} База данных не найдена и будет создана')
        init_db()  # переход в функцию создания базы данных

