#!/bin/bash

set -eu -o pipefail

# --------------------------------------------------------------------

if [ ! -d ~/bin/bats ]; then
  git clone https://github.com/sstephenson/bats.git ~/bin/bats
fi

cd ~/bin/bats
git pull origin master
