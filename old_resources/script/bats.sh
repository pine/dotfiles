#!/bin/bash

if [ -e "$HOME/bin/bats/bin/bats" ]; then
  exit
fi

set -eux

mkdir -p "$HOME/bin"
cd "$HOME/bin"
rm -rf ./bats

git clone https://github.com/sstephenson/bats.git
