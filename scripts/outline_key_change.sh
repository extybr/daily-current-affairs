#!/bin/bash

cd ~/my_programs/outline-sdk
pkill http2transport
rm outline.key 2> /dev/null
if [ -f outline_number ]; then
  number=$(( $(cat outline_number) + 1 ))
  echo "${number}" > outline_number
else echo '1' > outline_number
fi
unzip keys.zip "outline_${number}.key"
mv "outline_${number}.key" outline.key
cd ~/PycharmProjects/github/daily-current-affairs/scripts
./outline-sdk
 
