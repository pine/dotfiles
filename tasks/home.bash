#!/bin/bash

home_install() {
  local file
  local files="$DOTFILES_CONFIG/home/files.conf"
  local secured_files="$DOTFILES_SECURED_CONFIG/home/files.conf"
  local src

  cat $files | while read file; do
    _home_install_file "$DOTFILES_RESOURCES" "$file"
  done

  # Process secured files
  if [ -r "$secured_files" ]; then
    cat "$secured_files" | while read file; do
      _home_install_file "$DOTFILES_SECURED_RESOURCES" "$file"
    done
  fi
}

_home_install_file() {
  local resources="$1"
  local file="$2"
  local src="$resources/home/$file"
  local dest="$HOME/$file"
  local dest_dir="${dest%/*}"

  echo "> ln -s $src $dest"
  mkdir -p "$dest_dir"
  rm -f "$HOME/$file"
  ln -s "$src" "$HOME/$file"
}
