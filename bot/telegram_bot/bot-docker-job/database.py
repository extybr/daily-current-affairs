import os
import sqlite3


class Database:
    db = "vacancies.db"
    command_create = ('CREATE TABLE headhunter (company text, name text, '
                      'from_salary text, to_salary text, link text, '
                      'types text, date DATETIME, schedule text, '
                      'address text)')
    command_drop = "DROP TABLE headhunter"

    def command_database(self, command_sql: str) -> None:
        """
        Подключение к базе данных и выполнение переданной команды.
        :param command_sql: str
        :return: None
        """
        connect = sqlite3.connect(self.db, check_same_thread=False)
        cursor = connect.cursor()
        cursor.execute(command_sql)
        connect.commit()
        connect.close()

    def drop_database(self) -> None:
        """
        Удаление таблицы с базы данных и создание новой таблицы.
        :return: None
        """
        if os.path.exists(self.db):
            self.command_database(self.command_drop)
            self.command_database(self.command_create)

    def initialize_database(self) -> None:
        """
        Создание базы данных и таблицы при ее отсутствии.
        :return: None
        """
        if not [i for i in os.listdir('.') if i == self.db]:
            print('База данных отсутствует и будет создана')
            self.command_database(self.command_create)

    def insert_database(self, company: str, name: str, from_salary: str,
                        to_salary: str, link: str, types: str, date,
                        schedule: str, address: str) -> None:
        """
        Запись данных в таблицу базу данных.
        :param company: str
        :param name: str
        :param from_salary: str
        :param to_salary: str
        :param link: str
        :param types: str
        :param date: DATETIME
        :param schedule: str
        :param address: str
        :return: None
        """
        command_insert = (f"INSERT INTO headhunter (company, name, "
                          f"from_salary, to_salary, link, types, date, "
                          f"schedule, address) "
                          f"VALUES ('{company}', '{name}', '{from_salary}', "
                          f"'{to_salary}', '{link}', '{types}', '{date}', "
                          f"'{schedule}', '{address}')")
        self.command_database(command_insert)

    def read_database(self) -> str:
        """
        Передача данных с базы данных.
        :return: str
        """
        connect = sqlite3.connect(self.db, check_same_thread=False)
        cursor = connect.cursor()
        data = cursor.execute(f"SELECT * FROM headhunter "
                              f"WHERE date > '{os.environ.get('TIMESTAMP')}'")
        for variable in data:
            yield (f'  {variable[0]}  '.center(107, '*') +
                   f'\n\n🚮   Профессия: {variable[1]}\n'
                   f'😍   Зарплата: {variable[2]} - {variable[3]}\n'
                   f'⚜   Ссылка: {variable[4]}\n'
                   f'🐯   /{variable[5]}/   -🌼-   дата публикации: '
                   f'{variable[6].replace("T", " ")[:19]}   -🌻-   график '
                   f'работы: {variable[7]}\n🚘   Адрес: {variable[8]}\n')


database = Database()
