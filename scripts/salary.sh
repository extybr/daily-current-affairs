#!/bin/zsh

cd ~/PycharmProjects/gitlab/salary_analytics
venv/bin/python main.py
git add .; git commit -m "update"; git push

