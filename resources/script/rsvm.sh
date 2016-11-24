#!/bin/bash

if [ -d "$HOME/.rsvm" ]; then
  exit
fi

set -eux

curl -L https://raw.github.com/sdepold/rsvm/master/install.sh | sh
