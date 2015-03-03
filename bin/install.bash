#!/bin/bash

node_bin=
node_version=v0.10.33

cwd=`dirname "${0}"`

if type node > /dev/null 2>&1; then
  node_bin=`which node`
fi

if [ "$node_bin" = "" ]; then
  if [ ! -e "$HOME/.nodebrew" ]; then
    if [ -e "$HOME/nodebrew" ]; then
      rm -rf "$HOME/nodebrew"
    fi
    
    wget git.io/nodebrew -O ~/nodebrew
    perl ~/nodebrew setup
    
    rm -rf "$HOME/nodebrew"
  fi
  
  nodebrew_bin="$HOME/.nodebrew/current/bin/nodebrew"
  
  if [ -e "$nodebrew_bin" ]; then
    "$nodebrew_bin" install-binary $node_version
    "$nodebrew_bin" use $node_version
    
    if [ -e "$HOME/.nodebrew/current/bin/node" ]; then
      node_bin="$HOME/.nodebrew/current/bin/node"
    fi
  fi
fi

if [ "$node_bin" != "" ]; then
  echo "> $node_bin -v"
  "$node_bin" -v
  
  echo "> $node_bin $cwd/install.js"
  "$node_bin" "${cwd}/install.js"
else
  echo "Can't find Node.js (in PATH, nodebrew)" 1>&2
fi

# vim: se ts=2 sw=2 sts=2 et ft=sh :


