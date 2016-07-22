#!/bin/bash

set -eu

node_version=v4.4.7

#####################################################################

if [ ! -z ${DOTFILES_ENV+x} ]; then
  exec $*
fi

export DOTFILES_ENV=1

#####################################################################

# perl
echo "Installing Perl"

if uname -a | fgrep -i Darwin > /dev/null 2>&1; then
  true
else
  if ! type -p perl > /dev/null 2>&1; then
    set -x
    sudo apt-get update -y
    sudo apt-get install perl
    set +x
  fi
fi

# nodebrew
echo "Installing Node.js"

if [ ! -e ~/.nodebrew ]; then
  if [ -e ~/nodebrew ]; then
    rm -rf ~/nodebrew
  fi


  if type -p wget > /dev/null 2>&1; then
    wget git.io/nodebrew -O ~/nodebrew
  else
    curl -L http://git.io/nodebrew > ~/nodebrew
  fi

  perl ~/nodebrew setup
  rm -rf ~/nodebrew
fi

nodebrew_bin=~/.nodebrew/current/bin/nodebrew

if [ -x "$nodebrew_bin" ]; then
  "$nodebrew_bin" install-binary $node_version || true
  "$nodebrew_bin" use $node_version

  if [ -e ~/.nodebrew/current/bin/node ]; then
    PATH=$HOME/.nodebrew/current/bin:$PATH
  fi
fi


#####################################################################

IS_UBUNTU=0

if type -p apt-get > /dev/null 2>&1; then
  IS_UBUNTU=1
fi

export IS_UBUNTU

#####################################################################

cwd=`dirname "${0}"`

if type -p node > /dev/null 2>&1; then
  echo "> Node $(node -v)"
  echo "> NPM $(npm -v)"

  cd $cwd/..
  npm install

  echo "> $*"
  exec $*
else
  echo "Can't install Node.js by nodebrew" 1>&2
  exit 1
fi

# vim: se ts=2 sw=2 sts=2 et ft=sh :
