#!/bin/bash


# Install envs
anyenv_install() {
  local env
  local envs="$DOTFILES_CONFIG/anyenv/envs.conf"

  cat "$envs" | while read env; do
    echo "> anyenv install -s $env"
    anyenv install -s $env
  done
}

