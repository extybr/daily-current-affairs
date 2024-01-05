FROM python:alpine

ENV TG_TOKEN="my-telegram-token"
ENV TG_USER=123456789
ENV VACANCY="DevOps"
ENV TIMESTAMP="2024-01-01 01:00:00"
ENV TIMER=1
ENV TZ="Asia/Vladivostok"

WORKDIR /bot-docker-job

RUN pip install telebot requests schedule

COPY . .

ENTRYPOINT ["python", "main.py"]