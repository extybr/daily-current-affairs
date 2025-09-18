#!/bin/bash
# $> ./bible.sh
# Цитаты библии

response_html=$(curl -s "https://allbible.info/ajax/randomverse/")

text=$(echo "$response_html" | iconv -f windows-1251 -t UTF-8 2>/dev/null | grep -A 1 'id="sinodal"' | tail -n 1 | sed 's/<[^>]*>//g; s/^[ \t]*//; s/[ \t]*$//')
ref=$(echo "$response_html" | iconv -f windows-1251 -t UTF-8 2>/dev/null | grep -A 2 'class="w_verse_name"' | grep -o '>[^<]*<' | sed 's/[><]//g' | head -n 1)

# notify-send "$text [$ref]" -t 12000
# zenity --info --text "$text [$ref]" --width="500" --height="200"
echo -e "\033[1;36m$text\n\033[0;35m[$ref]\033[0m"
