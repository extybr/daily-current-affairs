#!/bin/bash
# ./encoding-cp1251-to-utf8.sh path/file.txt

yellow="\033[33m"
normal="\033[0m"

if [ "$#" -ne 1 ]; then 
  echo -e "${yellow} 1 parameter was expected, but passed $#${normal}"
  exit 0
fi

if ! command -V iconv &> /dev/null; then 
  echo -e "${yellow} Command 'iconv' not found${normal}"
  exit 0
fi

if ! [ -f "$1" ]; then 
  echo -e "${yellow} File not found${normal}"
  exit 0
fi

input_encoding='cp1251'
output_encoding='utf-8'
path=$(dirname "$1")
file=$(basename "$1")
new_file="${path}/${output_encoding}_${file}"

cat "$1" | iconv -f "${input_encoding}" | iconv -t "${output_encoding}" -o "${new_file}"

echo -e "*** ${yellow}Successfully${normal} ***\n${yellow}${new_file}${normal}"

