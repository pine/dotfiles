#!/bin/bash

set -eu -o pipefail

defaults write com.apple.screencapture show-thumbnail -bool FALSE
defaults write -g ApplePressAndHoldEnabled -bool false

