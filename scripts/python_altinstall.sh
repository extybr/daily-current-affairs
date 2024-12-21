#!/bin/bash

mmp='3.14.0'
pre_release='a3'

python3 -V
python2 -V

wget https://www.python.org/ftp/python/"${mmp}"/Python-"${mmp}${pre_release}".tar.xz

tar -xf Python-"${mmp}${pre_release}".tar.xz
cd Python-"${mmp}${pre_release}"

./configure
make
sudo make altinstall

ver=$(echo "$mmp" | sed 's/..$//')
python"$ver" -V

