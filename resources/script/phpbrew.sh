#!/bin/bash

set -eu -o pipefail

# --------------------------------------------------------------------

if [ ! -f ~/bin/phpbrew ]; then
  cd /tmp
  curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
  chmod +x phpbrew

  mv phpbrew ~/bin
fi
