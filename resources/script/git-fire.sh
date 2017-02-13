#!/bin/bash

set -eu

if [ -e "$HOME/bin/git-fire" ]; then
  exit
fi

mkdir -p $HOME/bin
cd $HOME/bin

curl -o git-fire https://raw.githubusercontent.com/qw3rtman/git-fire/master/git-fire
chmod +x git-fire
