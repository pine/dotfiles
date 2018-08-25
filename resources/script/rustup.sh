#!/bin/bash

set -eu -o pipefail

if [ ! -f "$HOME/.cargo/bin/rustup" ]; then
  rm -f /tmp/rustup.sh

  curl https://sh.rustup.rs -sSf -o /tmp/rustup.sh
  chmod +x /tmp/rustup.sh
  /tmp/rustup.sh -y

  rm -f /tmp/rustup.sh
fi

