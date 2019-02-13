#!/bin/bash

tasks_home_install() {
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

  if [ -z "$file" ]; then
    return
  fi
  if [ "${file:0:1}" = "#" ]; then
    return
  fi

  local src="$resources/home/$file"
  local dest="$HOME/$file"
  local dest_dir="${dest%/*}"

  echo "> ln -s $src $dest"
  mkdir -p "$dest_dir"
  rm -f "$HOME/$file"
  ln -s "$src" "$HOME/$file"
}
