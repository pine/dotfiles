# tasks/apt.bash

apt_install() {
  if ! is-macos && has-apt; then
    _apt_install_pkgs
  fi
}


_apt_install_pkgs() {
  local pkgs="$DOTFILES_CONFIG/apt/pkgs.conf"
  local pkg

  cat "$pkgs" | while read pkg; do
    if [ "${pkg:0:1}" == '#' ]; then
      continue
    fi

    pkg="${pkg%%\#*}"
    pkg="$(echo "$pkg" | tr -d '[:space:]')"

    if ! dpkg -s "$pkg" > /dev/null; then
      echo "> apt install $pkg -y"
      apt install "$pkg" -y
    fi
  done
}

