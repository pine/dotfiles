#!/bin/bash

script_install() {
  local basename
  local script
  local scripts="$DOTFILES_CONFIG/script/files.conf"

  cat "$scripts" | while read script; do
    basename="$DOTFILES_RESOURCE/script/$script"
    if [ -e "$basename.sh" ]; then
      echo "> $basename.sh"
      "$basename.sh"
    fi
  done
}
