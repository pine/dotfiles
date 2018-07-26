#!/bin/bash

if [ -e "/usr/local/bin/screen" ]; then
  exit
fi

if ! uname -a | fgrep -i Darwin > /dev/null; then
  exit
fi

cd ~/project

if [ ! -d "~/project/screen-for-OSX/.git" ]; then
  git clone https://github.com/FreedomBen/screen-for-OSX.git
fi

cd screen-for-OSX
./install.sh
