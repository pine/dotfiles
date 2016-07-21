#!/bin/bash

IS_UBUNTU=0

if type -p apt-get > /dev/null 2>&1; then
  IS_UBUNTU=1
fi

#####################################################################

export IS_UBUNTU

echo "> gulp $*"
gulp $*
