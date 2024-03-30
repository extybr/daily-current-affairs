#!/bin/sh
if grep --color -E "^alias $1=" ~/.zshrc
  then
    echo
fi
if whatis -s1:8 -r "^$1" 2>/dev/null | rg "^$1"
  then
    CMD=$(whatis -s1:8 -r "^$1" 2>/dev/null | rg "^$1" | cut -d " " -f1)
    echo
    for i in $CMD
      do
		printf "%s" "which $i: "; which "$i" 2>/dev/null
		printf "%s" "whereis "; whereis "$i" 2>/dev/null
		echo
	  done
fi
