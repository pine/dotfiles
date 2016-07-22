#!/bin/bash

set -eu

cwd=`dirname "${0}"`
cd $cwd/..

bin/env.sh npm start

# vim: se ts=2 sw=2 sts=2 et ft=sh :
