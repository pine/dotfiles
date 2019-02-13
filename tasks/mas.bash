# tasks/mas.bash

# Install AppStore packages
tasks_mas_install() {
  if is-macos; then
    _tasks_mas_install_pkgs
  fi
}

_tasks_mas_install_pkgs() {
  local installed_pkgs="$(mas list | cut -f1 -d ' ')"
  local pkgs="$DOTFILES_CONFIG/mas/pkgs.conf"
  local pkg

  cat "$pkgs" | while read pkg; do
    if [ -z "$pkg" ]; then
      continue
    fi
    if [ "${pkg:0:1}" = '#' ]; then
      continue
    fi
    pkg="${pkg%%\#*}"
    pkg="$(echo "$pkg" | tr -d '[:space:]')"

    if ! echo "$installed_pkgs" | fgrep "$pkg" > /dev/null; then
      echo "> mas info $pkg"
      mas info "$pkg"
      echo "> mas install $pkg"
      mas install "$pkg"
    fi
  done
}

