# tasks/pre-apt.bash

apt_preinstall() {
  if ! is-macos && has-apt; then
    _apt_update
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

