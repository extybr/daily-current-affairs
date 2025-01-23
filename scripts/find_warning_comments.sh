#!/bin/bash -
# $> ./find_warning_comments.sh /path/directory
# Рекурсивный поиск меток [TODO|FIXME|HACK|WARNING|ERROR|XXX|NOTE|BUG] в комментариях файлов с указанными расширениями

SRCPATH="$1"
TAGS="TODO|FIXME|HACK|WARNING|XXX:|NOTE|BUG"
ERRORTAG="# ERROR|ERROR:"

OUTPUT=$(find "${SRCPATH}" ! \( -path "*venv*" -or -path "*build*" \) \( -name "*.sh" -or -name "*.py" -or -name "*.go" \) -print0 | \
         xargs -0 grep -E --with-filename --line-number --only-matching "($TAGS).*\$|($ERRORTAG).*\$" | \
         sed "s/($TAGS)/ warning: \$1/ ; s/($ERRORTAG)/ error: \$1/" | nl)

echo "$OUTPUT"

if [[ "$OUTPUT" == *" error: "* ]]; then
  exit 1
fi

