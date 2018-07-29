#!/bin/bash

set -eu -o pipefail

# --------------------------------------------------------------------

if uname -a | fgrep Darwin > /dev/null; then
  if ! fgrep /usr/local/bin/fish /etc/shells > /dev/null; then
    echo /usr/local/bin/fish | sudo tee -a /etc/shells > /dev/null
  fi

  sh=$(dscl . -read "/Users/$(whoami)" UserShell)
  if ! echo "$sh" | fgrep /usr/local/bin/fish > /dev/null; then
    chsh -s /usr/local/bin/fish
  fi
fi


