
## <h3>Парсер вакансий <img src="https://i.hh.ru/logos/svg/hh.ru__min_.svg" height="32"/> по расписанию<h3>
* docker
* telebot
* sqlite3
* requests
* schedule
---
####
    docker build -t bot-docker-job .
####
    docker run -d --restart=always bot-docker-job
####
    docker run -d -e TIMESTAMP="2023-12-29 16:00:00" -e VACANCY="инженер" --name my_docker_bot --rm bot-docker-job
---
