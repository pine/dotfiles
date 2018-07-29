#!/bin/bash

set -eu -o pipefail

if uname | fgrep -i Darwin > /dev/null; then
  echo "========== setup brew =========="
  set -x
  if ! type -p brew > /dev/null 2>&1; then
    /usr/bin/ruby -e \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  set +x

  echo "========== setup git =========="
  set -x
  brew update || brew update
  brew install git
  brew cleanup -s
  set +x

else
  echo "========== setup apt =========="
  set -x
  sudo apt-get update -y
  set +x

  echo "========== setup git =========="
  set -x
  sudo apt-get install git -y
  set +x
fi


echo "========== setup repository =========="
set -x

mkdir -p ~/project/pine
cd ~/project/pine

if [ ! -d dotfiles ]; then
  git clone https://github.com/pine/dotfiles.git
fi
cd dotfiles

git fetch
git checkout master

set +x


echo "========== install dotfiles =========="
set -x
bash ./bin/install.sh
set +x

# vim: se ts=2 sw=2 sts=2 et ft=sh :
