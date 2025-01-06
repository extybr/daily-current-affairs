#!/bin/sh
ytdl() {
  pushd ~/PycharmProjects/github/ytdl
  venv/bin/python main.py
  popd
}
