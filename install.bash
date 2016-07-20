#!/bin/bash

set -eu

if uname | fgrep -i Darwin > /dev/null 2>&1; then
    echo "Darwin detected"
else
    echo "Linux detected"
    set -x

    sudo apt-get update -y
    sudo apt-get install git -y

    mkdir -p ~/project
    cd ~/project

    if [ ! -d dotfiles ]; then
      git clone https://github.com/pine/dotfiles.git
    fi
    cd dotfiles

    git fetch
    git checkout v2
    bash ,/bin/install.bash

    set +x
fi
