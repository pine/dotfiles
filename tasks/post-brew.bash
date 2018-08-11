#!/bin/bash


brew_postinstall() {
  if is-macos; then
    echo "> brew cleanup -s"
    brew cleanup -s
  fi
}
