#!/bin/bash

home_install() {
  local file
  local files="$DOTFILES_CONFIG/home/files.conf"
  local secured_files="$DOTFILES_SECURED_CONFIG/home/files.conf"
  local src

  cat $files | while read file; do
    _home_install_file "$file"
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

_home_install_file() {
  local file=$1
  local src="$DOTFILES_RESOURCE/home/$file"
  local dest="$HOME/$file"
  local dest_dir="${dest%/*}"

  echo "> ln -s $src $dest"
  mkdir -p "$dest_dir"
  rm -f "$HOME/$file"
  ln -s "$src" "$HOME/$file"
}
