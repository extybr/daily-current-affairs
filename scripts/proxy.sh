#!/bin/bash

proxy=''
if curl -s localhost:1080 &> /dev/null; then
  proxy="--proxy localhost:1080"
elif curl -s localhost:8080 &> /dev/null; then
  proxy="--proxy localhost:8080"
else source ./antizapret_proxy.sh
#else proxy="--proxy n.thenewone.lol:29976"
fi
echo "${proxy} "

