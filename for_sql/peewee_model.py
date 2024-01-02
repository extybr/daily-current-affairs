from peewee import *
from api import DB_NAME, DB_PASSWORD
# TODO: Класс-модель для ОРМ peewee

db = PostgresqlDatabase(database=DB_NAME, host='localhost', port=5432, user='postgres',
                        password=DB_PASSWORD)


class Users(Model):
    user_id = IntegerField(primary_key=True, null=False)
    user_name = TextField(null=True)
    user_surname = TextField(null=True)
    username = TextField(null=True)

    class Meta:
        database = db
        db_table = 'users'
