#!/bin/bash


tasks_brew_postinstall() {
  if env_is_macos; then
    echo "> brew cleanup -s"
    brew cleanup -s
  fi
}
