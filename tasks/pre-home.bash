#!/bin/bash


home_preinstall() {
  local mkdirp="$DOTFILES_CONFIG/home/mkdirp.conf"

  cat "$mkdirp" | while read dir; do
    echo "> mkdir -p ~/$dir"
    mkdir -p "~/$dir"
  done
}
