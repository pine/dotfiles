#!/bin/bash

if [ -f $HOME/bin/phpbrew ]; then
  exit 0
fi

set -eux

cd /tmp

curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
chmod +x phpbrew

mkdir -p $HOME/bin
mv phpbrew $HOME/bin
