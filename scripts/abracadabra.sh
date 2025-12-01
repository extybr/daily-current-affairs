#!/bin/bash
# $> ./abracadabra.sh "abracadabra"

if hash iconv 2>/dev/null; then true; else echo 'command `iconv` not found' && exit 0; fi

abracadabra="$1"

cur_dir=$(pwd)
cd "${SCRIPTS_DIRECTORY}"

echo 1: "$abracadabra" | iconv -t utf8
echo 2: "$abracadabra" | iconv -t cp1251
echo 3: "$abracadabra" | iconv -t 866
echo -n '4: ' && echo "$abracadabra" | base64 -d 2>/dev/null || echo FAIL
echo -n '5: ' && ./url_coder.py decoder "$abracadabra" 2>/dev/null || echo FAIL
echo -n '6: ' && ./url_coder.sh decoder "$abracadabra"
echo -n '7: ' && ./coder_html_decimal.py decoder "$abracadabra"

echo -e "\n iconv --help / iconv -l / man ascii"

cd "${cur_dir}"
