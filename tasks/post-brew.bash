#!/bin/bash


brew_postinstall() {
  echo "> brew cleanup -s"
  brew cleanup -s
}
