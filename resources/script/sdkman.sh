#!/bin/bash

if ! uname -a | fgrep -i Darwin > /dev/null; then
  exit
fi

if [ -d "$HOME/.sdkman" ]; then
  exit
fi

curl -s "https://get.sdkman.io" | bash
