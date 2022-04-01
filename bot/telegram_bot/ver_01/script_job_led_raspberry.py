#!/usr/bin/python
# -*- coding: utf-8 -*-
import requests
from time import sleep, localtime
from gpiozero import LED


def lamp() -> None:
    """ Включение светодиода (реле) с пина 25 RaspberryPi """
    led = LED(25)
    temp = localtime().tm_min
    while temp + 1 != localtime().tm_min:
        led.on()
        sleep(1)
        led.off()
        sleep(1)


def extract_jobs() -> None:
    """
    Парсер вакансий с сайта hh.ru
    :return: None
    """
    professional_role = '&professional_role=96'  # специализация '96': программист
    text_profession = '&text='
    area = '22'  # регион '22': Владивосток
    publication_time = 'order_by=publication_time&'
    period = '1'
    url = (f'https://api.hh.ru/vacancies?clusters=true&st=searchVacancy&enable_snippets=true&'
           f'{publication_time}period={period}&only_with_salary=false{professional_role}'
           f'{text_profession}&page=0&per_page=100&area={area}&responses_count_enabled=true')

    headers = {
        'Host': 'api.hh.ru',
        'User-Agent': 'Mozilla/5.0',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive'
    }

    print('Headhunter: парсинг вакансий')
    result = requests.get(url, headers)
    results = result.json()
    count_vacancies = results.get('found')
    print('Найдено результатов:', count_vacancies)
    print('\n' + '*' * 50 + '\n')
    with open('_vacancies.txt', 'w', encoding='utf-8') as text:
        text.write('Найдено результатов: ' + str(count_vacancies) + '\n\n')
    items = results.get('items', {})
    for index in items:
        company = index['employer']['name']
        name = index['name']
        link = index["alternate_url"]
        types = index['type']['name']
        date = index['published_at'][:10]
        address = index['area']['name']
        schedule = index['schedule']['name']
        if index['address']:
            address = index['address']['raw']
        salary = index['salary']
        if count_vacancies > 0:
            text = open('_vacancies.txt', 'a', encoding='utf-8')
            if salary:
                from_salary = salary['from']
                to_salary = salary['to']
                if not isinstance(from_salary, int):
                    from_salary = '😜'
                if not isinstance(to_salary, int):
                    to_salary = '🚀'
                output = (f'  {company}  '.center(50, '*') + f'\n\n🚮   Профессия: {name}\n😍   '
                          f'Зарплата: {from_salary} - {to_salary}\n⚜   Ссылка: {link}\n🐯   '
                          f'/{types}/   -🌼-   дата публикации: {date}   -🌻-   график работы: '
                          f'{schedule.lower()}\n🚘   Адрес: {address}\n')
                text.write(output.center(50, '*') + '\n')
            else:
                output = (f'  {company}  '.center(50, '*') + f'\n\n🚮   Профессия: {name}\n😍'
                          f'   Зарплата: не указана\n⚜   Ссылка: {link}\n🐯   /{types}/'
                          f'   -🌼-   дата публикации: {date}   -🌻-   график работы: '
                          f'{schedule.lower()}\n🚦   Количество откликов для вакансии: '
                          f'\n🚘   Адрес: {address}\n')
                text.write(output.center(50, '*') + '\n')
            text.close()


# если убрать условие ниже, то вакансии парсятся при старте бота
if __name__ == '__main__':
    try:
        extract_jobs()
    except OSError as error:
        print(f'Статус: проблемы с доступом в интернет\n{error}')
