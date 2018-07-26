#!/bin/bash

set -eu

if [ -e "$HOME/bin/gh-md-toc" ]; then
  exit
fi

mkdir -p $HOME/bin
cd $HOME/bin

wget https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc
chmod +x gh-md-toc
