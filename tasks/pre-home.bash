#!/bin/bash


tasks_home_preinstall() {
  local mkdirp="$DOTFILES_CONFIG/home/mkdirp.conf"

  cat "$mkdirp" | while read dir; do
    echo "> mkdir -p $HOME/$dir"
    mkdir -p "$HOME/$dir"
  done
}
