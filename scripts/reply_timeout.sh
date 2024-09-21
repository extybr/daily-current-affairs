#!/bin/bash
if read -t 10 -p "Enter your name: "
  then echo "Hello $REPLY, welcome to my program"
else echo "timeout ... bye, bye"
fi

