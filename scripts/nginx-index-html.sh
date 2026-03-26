#!/bin/bash
# $> sudo ./nginx-index-html.sh
# HACK: для правки после обновления/переустановки системы

HTML_PATH="/usr/share/nginx/html"

function check_path() {
  if ! grep -m 1 'location / {' /etc/nginx/nginx.conf -A 1 | tail -1 | \
  grep "$HTML_PATH" &>/dev/null; then
    echo -e "not found: \033[31m$HTML_PATH\033[0m in nginx.conf"
    exit
  fi
}

function fix_page() {
  if [ -f "${HTML_PATH}"/index.html ]; then
    sudo rm "${HTML_PATH}"/index.html
    sudo cp "${HTML_PATH}"/index.basic.html "${HTML_PATH}"/index.html
    echo 'file `index.html` copied'
  else echo 'file `index.html` missing'
  fi
}

function write_page() {
sudo echo '<!DOCTYPE html>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>security</title>
<meta content="security" name="author">
<meta content="security" name="description">
</head>

<body alink="#ee0000" link="#DAA520">
<style type="text/css">
html {
        background: url(grub-16x9.png) no-repeat center center fixed;
        -webkit-background-size: cover;
        -moz-background-size: cover;
        -o-background-size: cover;
        background-size: cover;
		}
		a:hover {  color: #66CC33; text-decoration: }
        a:link {  text-decoration: none}
        .image:hover {
        width:7%; 
        height:7%; 
        margin:0px;
        border:0px;
}
</style>
</body>
</html>
' > "${HTML_PATH}"/index.html

if ! [ -f "${HTML_PATH}"/grub-16x9.png ]; then
  echo 'image not found'
fi

}

check_path
# fix_page
write_page

