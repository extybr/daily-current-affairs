#!/bin/sh
pushd ~/PycharmProjects/github/youtube_latest_videos
venv/bin/python rss.py "$1"
popd
