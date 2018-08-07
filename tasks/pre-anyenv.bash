#!/bin/bash


# Install anyenv
anyenv_preinstall() {
  if [ -d ~/.anyenv ]; then
    pushd ~/.anyenv > /dev/null
    git pull origin master
    popd > /dev/null
  else
    git clone 'https://github.com/riywo/anyenv.git' ~/.anyenv
  fi

  PATH=~/.anyenv/bin:$PATH
  anyenv init - > /dev/null
}
