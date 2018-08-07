#!/bin/bash

anyenv_install() {
  _anyenv_install_envs
  _anyenv_update_envs
}

# Install anvs
_anyenv_install_envs() {
  local env
  local envs="$DOTFILES_CONFIG/anyenv/envs.conf"

  cat "$envs" | while read env; do
    echo "> anyenv install -s $env"
    anyenv install -s $env
  done
}

# Update envs
_anyenv_update_envs() {
  local env
  local envs="$DOTFILES_CONFIG/anyenv/envs.conf"

  cat "$envs" | while read env; do
    pushd "$HOME/.anyenv/envs/$env"
    git pull origin master
    popd
  done
}
