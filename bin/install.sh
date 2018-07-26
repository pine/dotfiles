#!/bin/bash

set -eu -o pipefail

# -------------------------------------------------------------------

DOTFILES_ROOT=$(cd ${BASH_SOURCE%/*}/..; pwd)
cd $DOTFILES_ROOT

DOTFILES_CONFIG=$DOTFILES_ROOT/config

# -------------------------------------------------------------------

install() {
  local f
  local tasks

  for f in $(find tasks -type f -name "*.bash"); do
    echo "Loading \`$f\`"
    . $f
  done

  tasks="$DOTFILES_CONFIG/tasks"
  for task in $(cat "$tasks"); do
    for action in preinstall install postinstall; do
      if type ${task}_$action > /dev/null 2>&1; then
        echo "Running \`${task}_$action\`"
        "${task}_$action"
      fi
    done
  done

  printf "\e[32msuccess\e[39m\n"
  printf "\xe2\x9c\xa8  Done in XXXs.\n"
}

install
