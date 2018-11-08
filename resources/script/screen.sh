#!/bin/bash

set -eu -o pipefail

# --------------------------------------------------------------------

if uname -a | fgrep -i Darwin > /dev/null; then
  if [ ! -f /usr/local/bin/screen ]; then
    mkdir -p ~/project/FreedomBen
    cd ~/project/FreedomBen

    if [ ! -d ~/project/FreedomBen/screen-for-OSX ]; then
      git clone https://github.com/FreedomBen/screen-for-OSX.git
    fi

    cd screen-for-OSX
    ./install.sh
  fi
fi

