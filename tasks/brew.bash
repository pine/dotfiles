# tasks/bash.bash


# Install brew packages
tasks_brew_install() {
  if is-macos; then
    _brew_install_pkgs
    _brew_install_cask_pkgs
  fi
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
      echo "> brew install $pkg"
      brew install "$pkg"
    fi
  done
}


_brew_install_cask_pkgs() {
  local installed_pkgs="$(brew list --cask | tr ' ' "\n")"
  local pkgs="$DOTFILES_CONFIG/brew/cask-pkgs.conf"
  local pkg


  cat "$pkgs" | while read pkg; do
    if [ "${pkg:0:1}" == '#' ]; then
      continue
    fi

    pkg="${pkg%%\#*}"
    pkg="$(echo "$pkg" | tr -d '[:space:]')"

    if ! echo "$installed_pkgs" | fgrep "$pkg" > /dev/null; then
      echo "> brew cask install $pkg"
      brew install "$pkg" --cask
    fi
  done
}

