## <h3>Парсер вакансий <img src="https://i.hh.ru/logos/svg/hh.ru__min_.svg" height="32"/> по расписанию<h3>

<details><summary>модули</summary>

* docker
* telebot
* sqlite3
* requests
* schedule
</details>

---
	
<details><summary>команды</summary>

сборка образа
####
    docker build -t hh-scheduler-tgbot .
запуск контейнера локального образа
####
    docker run -d -e TG_TOKEN="my-telegram-token" -e TG_USER=123456789 -e TIMER=10 \
    -e TIMESTAMP="2024-01-05 16:00:00" -e VACANCY="DevOps" --name hh_tgbot \
    --restart=always --rm hh-scheduler-tgbot
запуск контейнера удаленного образа
####
    docker run -d -e TG_TOKEN="my-telegram-token" -e TG_USER=123456789 -e TIMER=10 \
    -e TIMESTAMP="2024-01-05 16:00:00" -e VACANCY="DevOps" --name hh_tgbot \
    --rm registry.gitlab.com/extybr/hh-scheduler-tgbot:latest

</details>

---
