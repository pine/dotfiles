#!/bin/bash

if [ -d "$HOME/bin/the_silver_searcher/" ]; then
    exit 0
fi

if [ `uname` == "Darwin" ]; then
    brew install pkg-config
    brew install xz
    brew install pcre
else
  if type -P apt-get > /dev/null 2>&1; then
    sudo apt-get update -y
    sudo apt-get install automake libpcre3-dev liblzma-dev gcc pkg-config -y
  fi
fi

mkdir -p /tmp/the_silver_searcher
cd /tmp/the_silver_searcher

wget http://geoff.greer.fm/ag/releases/the_silver_searcher-0.31.0.tar.gz
tar xvfz the_silver_searcher-0.31.0.tar.gz

cd the_silver_searcher-0.31.0

./configure --prefix="$HOME/bin/the_silver_searcher"
make
make install

cd /tmp/
rm -rf /tmp/the_silver_searcher
