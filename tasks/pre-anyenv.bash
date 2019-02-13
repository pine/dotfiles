#!/bin/bash


# Install anyenv
tasks_anyenv_preinstall() {
  if [ -d ~/.anyenv ]; then
    pushd ~/.anyenv > /dev/null
    git pull origin master
    popd > /dev/null
  else
    git clone 'https://github.com/riywo/anyenv.git' ~/.anyenv
  fi

  PATH=$HOME/.anyenv/bin:$PATH
  if [ ! -d ~/.config/anyenv/anyenv-install/ ]; then
    anyenv install --force-init
  fi
  anyenv init -
}
