import os
import time
import schedule
from datetime import datetime
from parser import search_job
from database import database
from bot import bot

USER = os.environ.get('TG_USER')
VACANCY = os.environ.get('VACANCY')


def run_task() -> None:
    """ Выполняемая задача по расписанию """
    database.drop_database()
    database.initialize_database()
    search_job('', VACANCY, '113', '1')
    if os.path.exists('vacancies.db'):
        output = database.read_database()
        count = 0

        for line in output:
            bot.send_message(USER, line)
            count += 1
            time.sleep(5)

        os.environ['TIMESTAMP'] = str(datetime.now())[:19]
        local_time = os.environ['TIMESTAMP']
        bot.send_message(USER, 'Число вакансий, удовлетворяющих условию - '
                               '{}. время: {}'.format(count, local_time))
    else:
        print('\n\n' + '  База Данных отсутствует  '.center(107, '*'))


schedule.every().hour.do(run_task)
# schedule.every(5).minutes.do(run_task)


def start() -> None:
    """ Запуск задачи """
    while True:
        schedule.run_pending()
        time.sleep(1)
