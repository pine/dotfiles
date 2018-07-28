#!/bin/bash

set -eu -o pipefail

# --------------------------------------------------------------------

if uname -a | fgrep -i Darwin > /dev/null; then
  if [ ! -d "$HOME/.sdkman" ]; then
    curl -s "https://get.sdkman.io" | bash
  fi
fi
