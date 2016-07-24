#!/bin/bash

set -eu

echo "========== setup git =========="
if uname | fgrep -i Darwin > /dev/null 2>&1; then
  echo "Darwin detected"
  set -x

  if ! type -p brew > /dev/null 2>&1; then
    /usr/bin/ruby -e \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  sudo chown -R $USER /usr/local

  brew update || brew update
  brew install git
  brew cleanup -s

  set +x
else
  echo "Linux detected"
  set -x

  sudo apt-get update -y
  sudo apt-get install git -y

  set +x
fi


echo "========== setup repository =========="
set -x

mkdir -p ~/project
cd ~/project

if [ ! -d dotfiles ]; then
  git clone https://github.com/pine/dotfiles.git
fi
cd dotfiles

git fetch
git checkout v2
bash ./bin/install.sh

set +x

# vim: se ts=2 sw=2 sts=2 et ft=sh :
