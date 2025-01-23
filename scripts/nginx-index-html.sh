#!/bin/sh
# $> ./nginx-index-html.sh
# HACK: для правки после обновления/переустановки системы

html_path="/usr/share/nginx/html"
if [ -f "${html_path}"/index.html ]
  then
    sudo rm "${html_path}"/index.html
    sudo cp "${html_path}"/index.basic.html "${html_path}"/index.html
    echo 'file `index.html` copied'
  else 'file `index.html` missing'
fi

