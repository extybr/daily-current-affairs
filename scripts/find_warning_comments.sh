#!/bin/bash -
# $> ./find_warning_comments.sh /path/directory

SRCPATH="$1"
TAGS="TODO|FIXME|HACK|WARNING"
ERRORTAG="# ERROR|ERROR:"

OUTPUT=$(find "${SRCPATH}" \( -name "*.sh" -or -name "*.py" -or -name "*.go" \) -print0 | \
         xargs -0 grep -E --with-filename --line-number --only-matching "($TAGS).*\$|($ERRORTAG).*\$" | \
         sed "s/($TAGS)/ warning: \$1/ ; s/($ERRORTAG)/ error: \$1/" | nl)

echo "$OUTPUT"

if [[ $OUTPUT == *" error: "* ]]; then
  exit 1
fi

