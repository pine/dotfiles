# tasks/fish.bash

tasks_fish_install() {
  if type -p fish > /dev/null; then
    _fish_install_fisherman

    if [ -z "${CI:-}" ]; then
      _fish_set_default_shell
    fi
  fi
}


_fish_install_fisherman() {
  if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
    curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
  fi
  fish --login -c 'fisher install < $HOME/.config/fish/fishfile'
}


_fish_set_default_shell() {
  if is-macos; then
    if ! fgrep /usr/local/bin/fish /etc/shells > /dev/null; then
      echo /usr/local/bin/fish | sudo tee -a /etc/shells > /dev/null
    fi

    sh=$(dscl . -read "/Users/$(whoami)" UserShell)
    if ! echo "$sh" | fgrep /usr/local/bin/fish > /dev/null; then
      chsh -s /usr/local/bin/fish
    fi
  fi
}
