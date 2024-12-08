#!/bin/sh

########## Начало или конец текста ##########

text='Hello World'
if [[ "${text}" =~ ^(Hello|OK) ]]
  then echo "Текст начинается со слова Hello или OK"
elif [[ "${text}" =~ (World)$ ]]
  then echo "Текст заканчивается словом World"
fi

########## Срез текста до определенных букв (слов) ##########

if [ $# -ne 1 ]
  then echo "необходимо передать текст/буквы для среза"
  exit 0
fi

text="Hello World"  # основной текст, который нужно обрезать
result_before=${text%"$1"*}  # срез основного текста до переданного символа/слова
result_after=${text#*"$1"}  # срез основного текста после переданного символа/слова

echo "${text}"
echo "before: ${result_before}"
echo "after: ${result_after}"

########## Число символов строки ##########

string='Learn Bash Programming'
echo "Длина строки: $(echo ${#string})"  # число символов строки
echo "Длина строки: $(($(echo ${string} | wc -c) - 1))"
echo "Последний символ строки: ${string:$((${#string}-1)):1}"

########## Повторить n-ое количество раз ##########

myString=$(printf "%5s"); echo ${myString// /Hello-World }  # печать Hello-World 10 раз
number=20; myString=$(printf "%$((${number}-1))s"); echo "${myString}" "*"  # печать 20 пробелов перед *

########## Удаление пробелов ##########

trim_string() {
    # Usage: trim_string "   example   string    "
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

trim_string "    Hello,  World    "
name="   John Black  "
trim_string "$name"


# shellcheck disable=SC2086,SC2048
trim_all() {
    # Usage: trim_all "   example   string    "
    set -f
    set -- $*
    printf '%s\n' "$*"
    set +f
}

trim_all "    Hello,    World    "
name="   John   Black  is     my    name.    "
trim_all "$name"

########## Перевод букв в нижний регистр ##########

lower() {
    # Usage: lower "string"
    printf '%s\n' "${1,,}"
}

lower "HELLO"
lower "HeLlO"
lower "hello"

########## Перевод букв в верхний регистр ##########

upper() {
    # Usage: upper "string"
    printf '%s\n' "${1^^}"
}

upper "hello"
upper "HeLlO"
upper "HELLO"

########## Перевод букв в противоположный регистр ##########

reverse_case() {
    # Usage: reverse_case "string"
    printf '%s\n' "${1~~}"
}

reverse_case "hello"
reverse_case "HeLlO"
reverse_case "HELLO"

########## Удаление кавычек из строки ##########

trim_quotes() {
    # Usage: trim_quotes "string"
    : "${1//\'}"
    printf '%s\n' "${_//\"}"
}

var="'Hello', \"World\""
trim_quotes "$var"

########## Удаление символов из строки по шаблону ##########

strip_all() {
    # Usage: strip_all "string" "pattern"
    printf '%s\n' "${1//$2}"
}

strip_all "The Quick Brown Fox" "[aeiou]"
# Th Qck Brwn Fx
strip_all "The Quick Brown Fox" "[[:space:]]"
# TheQuickBrownFox
strip_all "The Quick Brown Fox" "Quick "
# The Brown Fox

########## Удаление символов из строки по шаблону (первое вхождение) ##########

strip() {
    # Usage: strip "string" "pattern"
    printf '%s\n' "${1/$2}"
}

strip "The Quick Brown Fox" "[aeiou]"
# Th Quick Brown Fox
strip "The Quick Brown Fox" "[[:space:]]"
# TheQuick Brown Fox

########## Удаление по шаблону из начала строки ##########

lstrip() {
    # Usage: lstrip "string" "pattern"
    printf '%s\n' "${1##$2}"
}

lstrip "The Quick Brown Fox" "The "
# Quick Brown Fox

########## Удаление по шаблону из конца строки ##########

rstrip() {
    # Usage: rstrip "string" "pattern"
    printf '%s\n' "${1%%$2}"
}

rstrip "The Quick Brown Fox" " Fox"
# The Quick Brown

########## Процентное кодирование строки ##########

urlencode() {
    # Usage: urlencode "string"
    local LC_ALL=C
    for (( i = 0; i < ${#1}; i++ )); do
        : "${1:i:1}"
        case "$_" in
            [a-zA-Z0-9.~_-])
                printf '%s' "$_"
            ;;

            *)
                printf '%%%02X' "'$_"
            ;;
        esac
    done
    printf '\n'
}

urlencode "https://github.com/dylanaraps/pure-bash-bible"
# https%3A%2F%2Fgithub.com%2Fdylanaraps%2Fpure-bash-bible

########## Декодирование строки с процентным кодированием ##########

urldecode() {
    # Usage: urldecode "string"
    : "${1//+/ }"
    printf '%b\n' "${_//%/\\x}"
}

urldecode "https%3A%2F%2Fgithub.com%2Fdylanaraps%2Fpure-bash-bible"
# https://github.com/dylanaraps/pure-bash-bible

########## Проверьте, содержит ли строка подстроку ##########

if [[ $var == *sub_string* ]]; then
    printf '%s\n' "sub_string is in var."
fi

# Inverse (substring not in string).
if [[ $var != *sub_string* ]]; then
    printf '%s\n' "sub_string is not in var."
fi

# This works for arrays too!
if [[ ${arr[*]} == *sub_string* ]]; then
    printf '%s\n' "sub_string is in array."
fi

case "$var" in
    *sub_string*)
        # Do stuff
    ;;

    *sub_string2*)
        # Do more stuff
    ;;

    *)
        # Else
    ;;
esac

########## Проверьте, начинается ли строка с подстроки ##########

if [[ $var == sub_string* ]]; then
    printf '%s\n' "var starts with sub_string."
fi

# Inverse (var does not start with sub_string).
if [[ $var != sub_string* ]]; then
    printf '%s\n' "var does not start with sub_string."
fi

########## Проверьте, заканчивается ли строка вложенной строкой ##########

if [[ $var == *sub_string ]]; then
    printf '%s\n' "var ends with sub_string."
fi

# Inverse (var does not end with sub_string).
if [[ $var != *sub_string ]]; then
    printf '%s\n' "var does not end with sub_string."
fi

########## 0 ##########








