#!/bin/bash

set -eu -o pipefail

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# -------------------------------------------------------------------

declare -r DOTFILES_PARENT="$HOME/project/pine"
declare -r DOTFILES_ROOT="$DOTFILES_PARENT/dotfiles"
declare -r DOTFILES_BIN="$DOTFILES_ROOT/bin"
declare -r DOTFILES_GIT_HTTPS="https://github.com/pine/dotfiles.git"
declare -r DOTFILES_GIT_SSH="git@github.com:pine/dotfiles.git"

# -------------------------------------------------------------------

setup() {
  echo "Installing dotfiles"

  echo "> mkdir -p $DOTFILES_PARENT"
  mkdir -p "$DOTFILES_PARENT"
  cd "$DOTFILES_PARENT"

  # Install git
  if ! type -p git > /dev/null; then
    # macOS
    if uname -a | fgrep -i Darwin > /dev/null; then
      :
    # Ubuntu
    elif type -p apt > /dev/null; then
      sudo apt update -y
      sudo apt-get install git -y
      sudo apt autoremove -y
    fi
  fi

  # Clone Git repository
  if [ ! -d dotfiles ]; then
    echo "> git clone $DOTFILES_GIT_HTTPS $DOTFILES_ROOT"
    git clone "$DOTFILES_GIT_HTTPS" "$DOTFILES_ROOT"
  fi
  cd "$DOTFILES_ROOT"
  git remote set-url origin "$DOTFILES_GIT_SSH"

  # Install dotfiles
  echo "> $DOTFILES_BIN/install.sh"
  "$DOTFILES_BIN/install.sh"
}

setup

# vim: se ts=2 sw=2 sts=2 et ft=sh :
