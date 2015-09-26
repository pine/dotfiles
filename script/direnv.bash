#!/bin/bash

if type -P direnv > /dev/null 2>&1; then
    exit 0
fi

if ! go version > /dev/null 2>&1; then
    goenv install 1.5
    goenv global 1.5
    goenv rehash
fi

rm -rf /tmp/direnv_work
mkdir /tmp/direnv_work
cd /tmp/direnv_work

git clone --depth=1 https://github.com/direnv/direnv
cd direnv
make install DESTDIR=$HOME/bin/direnv

cd $HOME
rm -rf /tmp/direnv
