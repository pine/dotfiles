#!/bin/bash

if [ -f "/usr/local/bin/screen" ]; then
    exit 0
fi

mkdir -p /tmp/screen_for_osx
cd /tmp/screen_for_osx

brew install autoconf
brew install automake

git clone https://github.com/FreedomBen/screen-for-OSX.git
cd screen-for-OSX
./install.sh

cd $HOME
rm -rf /tmp/screen_for_osx

