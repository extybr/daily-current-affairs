#!/bin/bash
# $> ls-recursive.sh path/directory

cat << EOF

😄 ls *
😄 echo "bHMgKg==" | base64 -d | bash
😄 ls -R
😄 du -a .
😄 find . -print
😄 tree .
😄 dir -1
😄 diff -r -u "$HOME/folder_1" "$HOME/folder_2"

EOF

path="$1"

if [ "$#" -ne 1 ] || ! [ -d "$path" ]; then
  echo "*** Путь не найден ***"
  exit
fi

function Ls {
  eval "$1"
  echo
}

for cmd in 'ls *' 'ls -R' 'echo "bHMgKg==" | base64 -d | bash' 'du -a .' 'find . -print' 'tree .' 'dir -1'; do
  Ls "$cmd"
done
exit

