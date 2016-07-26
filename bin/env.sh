#!/bin/bash

set -eu

#####################################################################

READLINK=$(type -p greadlink readlink | head -1)
if [ -z "$READLINK" ]; then
  echo "cannot find readlink - are you missing GNU coreutils?" >&2
  exit 1
fi

resolve_link() {
  $READLINK "$1"
}

realpath() {
  local cwd="$PWD"
  local path="$1"
  local name

  while [ -n "$path" ]; do
    local name="${path##*/}"
    [ "$name" = "$path" ] || cd "${path%/*}"
    path="$(resolve_link "$name" || true)"
  done

  echo "$PWD/$name"
  cd "$cwd"
}

cwd=`realpath $(dirname "$0")`
node_version=`cat $cwd/../.node-version`

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
PRIVATE_REPOSITORY=dotfiles.private

if type -p apt-get > /dev/null 2>&1; then
  IS_UBUNTU=1
fi

export IS_UBUNTU
export PRIVATE_REPOSITORY

#####################################################################

if type -p node > /dev/null 2>&1; then
  echo "> node -v"
  node -v
  echo "> npm -v"
  npm -v

  cd $cwd/..
  echo "> npm install"
  npm install

  private_path=$cwd/../../dotfiles.private
  if [ -d "$private_path" ]; then
    cd "$private_path"
    echo "> npm install <private>"
    npm install
  fi

  cd $cwd/..
  echo "> $*"
  exec $*
else
  echo "Can't install Node.js by nodebrew" 1>&2
  exit 1
fi

# vim: se ts=2 sw=2 sts=2 et ft=sh :
