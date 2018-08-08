#!/bin/bash


brew_postinstall() {
  if uname -a | fgrep -i Darwin > /dev/null; then
    echo "> brew cleanup -s"
    brew cleanup -s
  fi
}
