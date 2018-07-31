#!/bin/bash

home_install() {
  local file
  local files="$DOTFILES_CONFIG/home/files.conf"
  local secured_files="$DOTFILES_SECURED_CONFIG/home/files.conf"
  local src

  # Process files
  cat "$files" | while read file; do
    src="$DOTFILES_RESOURCE/home/$file"

    echo "> ln -s $src ~/$file"
    rm -f "~/$file"
    ln -s "$src" "~/$file"
  done

  # Process secured files
  if [ -r "$secured_files" ]; then
    cat "$secured_files" | while read file; do
      src="$DOTFILES_SECURED_RESOURCES/home/$file"

      echo "> ln -s $src ~/$file"
      rm -f "~/$file"
      ln -s "$src" "~/$file"
    done
  fi
}
