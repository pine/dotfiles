#!/bin/bash

set -eu -o pipefail

# macOS system preferences (migrated from the former `pref` task).
if [ "$(uname)" != 'Darwin' ]; then
  exit 0
fi

# Appearance: enable dark mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

# defaults
defaults write com.apple.screencapture show-thumbnail -bool FALSE
defaults write -g ApplePressAndHoldEnabled -bool false
