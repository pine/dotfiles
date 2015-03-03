#!/bin/bash

node_bin=

if type node > /dev/null 2>&1; then
  node_bin=`which node`
fi


if [ "$node_bin" != "" ]; then
  cwd=`dirname "${0}"`
  
  echo "> $node_bin $cwd/install.js"
  "$node_bin" "${cwd}/install.js"
else
  echo "Can't find Node.js (in PATH)" 1>&2
fi

# vim: se ts=2 sw=2 sts=2 et ft=sh :


