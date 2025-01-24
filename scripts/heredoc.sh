#!/bin/bash
# $> ./heredoc.sh
# heredoc

char() {
  ch=$(printf "%30s")
  echo -e "\n\e[37m${ch// /'*' }\e[0m\n"
}

char

cat << END
Hello $USER
files in $PWD:
$(ls | paste - - - -)
END

char

cat << EOF
Hello $USER
files in $PWD:
$(ls | paste - - - -)
EOF

char

cat << 'EOF'
Hello $USER
files in $PWD:
$(ls | paste - - - -)
EOF

char

cat << ''
Hello

echo world

char

