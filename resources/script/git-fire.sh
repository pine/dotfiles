#!/bin/bash

set -eu -o pipefail

# --------------------------------------------------------------------

if [ ! -f "$HOME/bin/git-fire" ]; then
  cd /tmp
  curl -o git-fire https://raw.githubusercontent.com/qw3rtman/git-fire/master/git-fire
  chmod +x git-fire

  mv git-fire ~/bin
fi
