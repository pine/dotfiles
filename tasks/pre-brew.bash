#!/bin/bash


# Setup Homebrew
brew_preinstall() {
  _brew_init
  _brew_update
  _brew_taps
  _brew_update
  _brew_upgrade
}


_brew_init() {
  local name

  for name in Caskroom Cellar Frameworks etc include lib opt var; do
    if [ ! -d "/usr/local/$name" ]; then
      sudo mkdir "/usr/local/$name"
    fi
    if [ "$(stat -f "%Su" "/usr/local/$name")" != "$(whoami)" ]; then
      sudo chown -R "$(whoami)" "/usr/local/$name"
    fi
  done
}

_brew_update() {
  local opts="$DOTFILES_CONFIG/brew/opts.conf"
  local fg

  fg="$(grep update $opts)"
  fg="${fg##update}"

  if [[ "$fg" = *on* ]]; then
    echo "> brew update"
    brew update || brew update
  fi
}


_brew_taps() {
  local installed_taps="$(brew tap | tr ' ' "\n")"
  local taps="$DOTFILES_CONFIG/brew/taps.conf"
  local tap

  cat "$taps" | while read tap; do
    if ! echo "$installed_taps" | fgrep "$tap" > /dev/null; then
      echo "> brew tap \"$tap\""
      brew tap "$tap"
    fi
  done

  echo "> brew tap --repair"
  brew tap --repair
}


_brew_upgrade() {
  local opts="$DOTFILES_CONFIG/brew/opts.conf"
  local fg

  fg="$(grep upgrade $opts)"
  fg="${fg##upgrade}"

  if [[ "$fg" = *on* ]]; then
    echo "> brew upgrade"
    brew upgrade || brew upgrade
  fi
}
