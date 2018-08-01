#!/bin/bash

fish_install() {
  if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
    curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
  fi

  fish --login -c 'fisher'
}
