#!/bin/bash


# Install brew packages
brew_install() {
  _brew_install_pkgs
  _brew_install_cask_pkgs
}


_brew_install_pkgs() {
  local installed_pkgs="$(brew list | tr ' ' "\n")"
  local pkgs="$DOTFILES_CONFIG/brew/pkgs.conf"
  local pkg

  cat "$pkgs" | while read pkg; do
    if [ "${pkg:0:1}" == '#' ]; then
      continue
    fi

    pkg="${pkg%%\#*}"
    pkg="$(echo "$pkg" | tr -d '[:space:]')"

    if ! echo "$installed_pkgs" | fgrep "$pkg" > /dev/null; then
      set -x
      brew install "$pkg"
      set +x
    fi
  done
}


_brew_install_cask_pkgs() {
  local installed_pkgs="$(brew cask list | tr ' ' "\n")"
  local pkgs="$DOTFILES_CONFIG/brew/cask_pkgs.conf"
  local pkg


  cat "$pkgs" | while read pkg; do
    if [ "${pkg:0:1}" == '#' ]; then
      continue
    fi

    pkg="${pkg%%\#*}"
    pkg="$(echo "$pkg" | tr -d '[:space:]')"

    if ! echo "$installed_pkgs" | fgrep "$pkg" > /dev/null; then
      set -x
      brew cask install "$pkg"
      set +x
    fi
  done
}

