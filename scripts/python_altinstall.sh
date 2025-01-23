#!/bin/bash
# $> ./python_altinstall.sh 3.14.0 a3
# WAGNING: Установка другой версии python

if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
   echo "Ожидалось 1 или 2 параметра"
   exit 0
fi

mmp="$1"
pre_release=""

if [ "$#" == 2 ]; then
  pre_release="$2"
fi

python3 -V
python2 -V

wget https://www.python.org/ftp/python/"${mmp}"/Python-"${mmp}${pre_release}".tar.xz

tar -xf Python-"${mmp}${pre_release}".tar.xz
cd Python-"${mmp}${pre_release}"

./configure --enable-optimizations --prefix="$HOME/.python${mmp}"
make
sudo make altinstall

ver=$(echo "${mmp}" | sed 's/..$//')
python"${ver}" -V

