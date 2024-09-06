#!/bin/sh
title=$(echo "$1" | sed 's/ /+/g')
curl -s --max-time 10 "https://btdig.com/search?order=0&q=${title}" | grep -oP 'magnet[^>]+" t' | sed 's/" t//g'
