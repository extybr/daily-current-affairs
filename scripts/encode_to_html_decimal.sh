#!/bin/bash

encode_to_html_decimal() {
    local input="$1"
    local output=""
    
    for (( i=0; i<${#input}; i++ )); do
        char="${input:i:1}"
        case "$char" in
            ',') output+="&#44;" ;;
            '<') output+="&#60;" ;;
            '>') output+="&#62;" ;;
            '&') output+="&#38;" ;;
            '!') output+="&#33;" ;;
            '"') output+="&#34;" ;;
            "'") output+="&#39;" ;;
            ':') output+="&#58;" ;;
            ';') output+="&#59;" ;;
            '?') output+="&#63;" ;;
            '-') output+="&#45;" ;;
            '(') output+="&#40;" ;;
            ')') output+="&#41;" ;;
            '/') output+="&#47;" ;;
            '\\') output+="&#92;" ;;
            '#') output+="&#35;" ;;
            '*') output+="&#42;" ;;
            '+') output+="&#43;" ;;
            '=') output+="&#61;" ;;
            '`') output+="&#96;" ;;
            '{') output+="&#123;" ;;
            '}') output+="&#125;" ;;
            '[') output+="&#91;" ;;
            ']') output+="&#93;" ;;
            '|') output+="&#124;" ;;
            '^') output+="&#94;" ;;
            '~') output+="&#126;" ;;
            '“') output+="&#8220;" ;;
            '”') output+="&#8221;" ;;
            *) output+="$char" ;;  # Оставляем остальные символы без изменений
        esac
    done

    echo "$output"
}

