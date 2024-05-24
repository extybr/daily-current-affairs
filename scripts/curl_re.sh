#!/bin/sh
pushd ~/PycharmProjects/github/youtube_latest_videos
python curl_re.py "$1"
popd
