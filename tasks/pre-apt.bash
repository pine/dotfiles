# tasks/pre-apt.bash


apt_preinstall() {
  if ! is-macos && has-apt; then
    _apt_update
    _apt_install_pre_pkgs
    _apt_add_repositories
  fi
}


_apt_update() {
  local opts="$DOTFILES_CONFIG/apt/opts.conf"
  local fg

  fg="$(grep update $opts)"
  fg="${fg##update}"

  if [[ "$fg" = *on* ]]; then
    echo "> sudo apt update"
    sudo apt update || sudo apt update
  fi
}


_apt_install_pre_pkgs() {
  local pkgs="$DOTFILES_CONFIG/apt/pre-pkgs.conf"
  local pkg

  cat "$pkgs" | while read pkg; do
    if ! dpkg -s "$pkg" > /dev/null; then
      echo "> sudo apt install $pkg -y -qq"
      sudo apt install "$pkg" -y -qq
    fi
  done
}


_apt_add_repositories() {
  local pattern
  local repo
  local repos="$DOTFILES_CONFIG/apt/repos.conf"
  local source

  cat "$repos" | while read repo; do
    repo="$(echo "$repo" | tr '\t' ' ')"

    pattern="${repo%% *}"
    if [ -z "$pattern" ]; then
      continue
    fi

    source="${repo##* }"
    if [ -z "$source" ]; then
      continue
    fi

    echo $pattern
    echo $source
  done

  # cat "/etc/apt/sources.list.d/*.list"
}
