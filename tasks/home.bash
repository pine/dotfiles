#!/bin/bash

home_install() {
  local file
  local files="$DOTFILES_CONFIG/home/files.conf"
  local src

  cat $files | while read file; do
    src="$DOTFILES_RESOURCE/home/$file"

    echo "> ln -s $src ~/$file"
    rm -f "~/$file"
    ln -s "$src" "~/$file"
  done
}
