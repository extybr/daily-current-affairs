#!/bin/bash
# $> ./bible.sh
# Цитаты библии

decoded_html=$(curl -s "https://allbible.info/ajax/randomverse/" | iconv -f cp1251 -t utf8 2>/dev/null)

text=$(echo "$decoded_html" | grep -A 1 'id="sinodal"' | tail -n 1 | sed 's/<[^>]*>//g; s/^[[:space:]]*//; s/[[:space:]]*$//')
ref=$(echo "$decoded_html" | grep -A 2 'class="w_verse_name"' | grep -o '>[^<]*<' | sed 's/[><]//g' | head -n 1)

# echo "$decoded_html" | awk '/id="sinodal"/ {getline; gsub(/<[^>]*>/, ""); gsub(/^[[:space:]]+|[[:space:]]+$/, ""); text=$0}
#     /class="w_verse_name"/ {for(i=1; i<=2; i++) {getline; if(match($0, />[^<]+</)) {ref=substr($0, RSTART+1, RLENGTH-2); exit}}}
#     END {printf "\033[1;36m%s\n\033[0;35m[%s]\033[0m\n", text, ref}'

# notify-send "$text [$ref]" -t 12000
# zenity --info --text "$text [$ref]" --width="500" --height="200"
echo -e "\033[1;36m$text\n\033[0;35m[$ref]\033[0m"

