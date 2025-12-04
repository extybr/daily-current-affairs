#!/bin/bash
# $> ./nato-words.sh Hello World 123
# Слова Североатлантического альянса / Words of the North Atlantic Alliance

word=$(echo "$@" | tr [:upper:] [:lower:])

declare -A DICTIONARY

DICTIONARY=(
    ["a"]="Alfa"
    ["b"]="Bravo"
    ["c"]="Charlie"
    ["d"]="Delta"
    ["e"]="Echo"
    ["f"]="Foxtrot"
    ["g"]="Golf"
    ["h"]="Hotel"
    ["i"]="India"
    ["j"]="Juliett"
    ["k"]="Kilo"
    ["l"]="Lima"
    ["m"]="Mike"
    ["n"]="November"
    ["o"]="Oscar"
    ["p"]="Papa"
    ["q"]="Quebec"
    ["r"]="Romeo"
    ["s"]="Sierra"
    ["t"]="Tango"
    ["u"]="Uniform"
    ["v"]="Victor"
    ["w"]="Whiskey"
    ["x"]="X-ray"
    ["y"]="Yankee"
    ["z"]="Zulu"
    ["1"]="One"
    ["2"]="Two"
    ["3"]="Three"
    ["4"]="Four"
    ["5"]="Five"
    ["6"]="Six"
    ["7"]="Seven"
    ["8"]="Eight"
    ["9"]="Nine"
    ["0"]="Zero"
    [" "]=" "
)

for (( i=0; i<${#word}; i++ )); do
    char="${word:$i:1}"
    echo -n "${DICTIONARY[$char]}"
done
  
