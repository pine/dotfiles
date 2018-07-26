#!/bin/bash


# Install brew packages
brew_install() {
  _brew_install_pkgs
  _brew_install_cask_pkgs
}


_brew_install_pkgs() {
  local installed_pkgs
  local pkgs
  local pkg

  installed_pkgs="$(brew list | tr ' ' "\n")"
  pkgs="$DOTFILES_CONFIG/brew/pkgs.conf"

  cat "$pkgs" | while read pkg; do
    if [ "${pkg:0:1}" == '#' ]; then
      continue
    fi

    pkg="${pkg%%\#*}"
    pkg="${pkg%% *}"

    if ! echo "$installed_pkgs" | fgrep "$pkg" > /dev/null; then
      set -x
      brew install "$pkg"
      set +x
    fi
  done
}


_brew_install_cask_pkgs() {
  local installed_pkgs
  local pkgs
  local pkg

  installed_pkgs="$(brew cask list | tr ' ' "\n")"
  pkgs="$DOTFILES_CONFIG/brew/cask_pkgs.conf"

  cat "$pkgs" | while read pkg; do
    if [ "${pkg:0:1}" == '#' ]; then
      continue
    fi

    pkg="${pkg%%\#*}"
    pkg="${pkg%% *}"

    if ! echo "$installed_pkgs" | fgrep "$pkg" > /dev/null; then
      set -x
      brew cask install "$pkg"
      set +x
    fi
  done
}

