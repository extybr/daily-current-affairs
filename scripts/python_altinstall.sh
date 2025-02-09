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

wget https://www.python.org/ftp/python/"${mmp}"/Python-"${mmp}${pre_release}".tar.xz

tar -xf Python-"${mmp}${pre_release}".tar.xz
cd Python-"${mmp}${pre_release}"

./configure --enable-optimizations --prefix="$HOME/.python${mmp}"
make
sudo make altinstall

rm Python-"${mmp}${pre_release}".tar.xz
rm -r Python-"${mmp}${pre_release}"
sudo ln -s $HOME/.python${mmp}/bin/python${mmp} /usr/bin
# export PATH=$PATH:$HOME/.python${mmp}/bin

# cd project; rm venv/bin/python*; ln -s $HOME/.python${mmp}/bin/python${mmp} ./;
# cp python${mmp} python3; cp python${mmp} python

if [ "$#" -eq 2 ]; then
  ver=$(echo "${mmp}" | sed 's/..$//')
else
  ver="${mmp}"
fi

python"${ver}" -V
python3 -V
python2 -V 2> /dev/null

