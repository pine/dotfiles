#!/bin/bash

fish_install() {
  _fish_install_fisherman
  _fish_set_default_shell
}


_fish_install_fisherman() {
  if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
    curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
  fi
  fish --login -c 'fisher < $HOME/.config/fish/fishfile'
}


_fish_set_default_shell() {
  if uname -a | fgrep Darwin > /dev/null; then
    if ! fgrep /usr/local/bin/fish /etc/shells > /dev/null; then
      echo /usr/local/bin/fish | sudo tee -a /etc/shells > /dev/null
    fi

    sh=$(dscl . -read "/Users/$(whoami)" UserShell)
    if ! echo "$sh" | fgrep /usr/local/bin/fish > /dev/null; then
      chsh -s /usr/local/bin/fish
    fi
  fi
}
