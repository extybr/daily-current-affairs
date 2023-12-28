import requests
from database import database


def search_job(telegram_role: str, telegram_profession: str,
               telegram_area: str, telegram_period: str) -> None:
    """  Парсер вакансий с сайта hh.ru """
    print(f'Переданы параметры: {telegram_role}, {telegram_profession}, '
                f'{telegram_area}, {telegram_period}')
    try:
        professional_role = f'&professional_role={telegram_role}' if len(
            telegram_role) > 1 else ''
        text_profession = f'&text={telegram_profession}'
        area = telegram_area
        publication_time = 'order_by=publication_time&'
        period = telegram_period
        url = (f'https://api.hh.ru/vacancies?clusters=true&st=searchVacancy&'
               f'enable_snippets=true&{publication_time}period={period}&'
               f'only_with_salary=false{professional_role}{text_profession}&'
               f'page=0&per_page=100&area={area}&responses_count_enabled=true')

        headers = {
            'Host': 'api.hh.ru',
            'User-Agent': 'Mozilla/5.0',
            'Accept': '*/*',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive'
        }

        print('hh.ru: парсинг вакансий')
        result = requests.get(url, headers)
        results = result.json()
        count_vacancies = results.get('found')
        print(f'Найдено результатов: {count_vacancies}')
        items = results.get('items', {})
        for index in items:
            company = index.get('employer', 0).get('name', 0)
            name = index.get('name', 0)
            link = index.get("alternate_url", 0)
            types = index.get('type', 0).get('name', 0)
            date = index.get('published_at', 0).replace('T', ' ')[:19]
            address = index.get('area', 0).get('name', 0)
            schedule = index.get('schedule', 0).get('name', 0)
            if index.get('address'):
                address = index.get('address').get('raw', 0)
            salary = index.get('salary', 0)
            if count_vacancies > 0:
                if salary:
                    from_salary = salary.get('from', 0)
                    to_salary = salary.get('to', 0)
                    if not isinstance(from_salary, int):
                        from_salary = '😜'
                    if not isinstance(to_salary, int):
                        to_salary = '🚀'
                    database.insert_database(company, name, str(from_salary),
                                             str(to_salary), link, types,
                                             date, schedule.lower(), address)
                else:
                    database.insert_database(company, name, 'не указана',
                                             'не указана', link, types, date,
                                             schedule.lower(), address)
    except OSError as error:
        print(f'Статус: проблемы с доступом в интернет\n{error}')
