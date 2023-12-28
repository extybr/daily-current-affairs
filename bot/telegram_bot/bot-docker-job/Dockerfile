FROM python:alpine

ENV TG_TOKEN="my-token"
ENV TG_USER=000000000
ENV VACANCY="инженер"
ENV TIMESTAMP="2023-12-28 01:00:00"
ENV TZ="Asia/Vladivostok"

WORKDIR /bot-docker-job

RUN pip install telebot requests schedule

COPY . .

ENTRYPOINT ["python", "main.py"]