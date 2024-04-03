# tasks/bash.bash


# Install brew packages
tasks_brew_install() {
  if is-macos; then
    _brew_install_pkgs "$DOTFILES_CONFIG/brew/pkgs.conf" formula
    _brew_install_pkgs "$DOTFILES_CONFIG/brew/cask-pkgs.conf" cask
  fi
}


_brew_install_pkgs() {
  local config_path=$1
  local repository=$2
  local line
  local pkg
  local state

  while read -u 9 line; do
    pkg=$(config_get_nth "$line" 0)
    if [ -z "$pkg" ]; then
      continue
    fi

    state=$(config_get_opt "$line" 'state' 'present')
    env=$(config_get_opt "$line" 'env' 'all')
    if [ "$env" != 'all' ] && [ "$(env_current)" != "$env" ]; then
      continue
    fi

    if [ "$state" = 'present' ]; then
      echo -n "Checking if $pkg is installed ... "
      if brew list $pkg "--$repository" > /dev/null 2>&1; then
        echo 'yes'
        continue # already installed
      else
        echo 'no'
      fi
      echo "Installing $pkg ..."
      brew install "$pkg" "--$repository" --no-quarantine
    elif [ "$state" = 'absent' ]; then
      echo -n "Checking if $pkg is uninstalled ... "
      if brew list $pkg "--$repository" > /dev/null 2>&1; then
        echo 'no'
      else
        echo 'yes'
        continue # already uninstalled
      fi
      echo "Uninstalling $pkg ..."
      brew uninstall "$pkg" "--$repository"
    fi
  done 9< "$config_path"
}
