#!/bin/bash
# $> ./pycompile.sh path/filename.py

if ! [[ -f "$1" ]]; then
  echo '*** файл не найден ***' && exit 1
fi
filename=$(basename "$1")
filedir=$(dirname "$1")
name=${filename%.py}
pyversion=$(python3 -V | awk -F. '{print 3$2}')
filecompile="${filedir}/__pycache__/${name}.cpython-${pyversion}.pyc"
python3 -c "import py_compile; py_compile.compile('$filename', cfile='$filecompile')"
