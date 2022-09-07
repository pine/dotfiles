#!/bin/bash

set -eu -o pipefail

declare -r JASYPT_DOWNLOAD_URL="https://github.com/jasypt/jasypt/releases/download/jasypt-1.9.3/jasypt-1.9.3-dist.zip"

# --------------------------------------------------------------------

if [ -d "$HOME/opt/jasypt" ]; then
  exit
fi

# --------------------------------------------------------------------

tmpdir=$(mktemp -d)
trap "rm -rf $tmpdir" EXIT

cd $tmpdir
curl -L -o jasypt.zip "$JASYPT_DOWNLOAD_URL"
unzip jasypt.zip
rm jasypt.zip
mv jasypt-* jasypt
mv jasypt $HOME/opt/

cd $HOME/opt
chmod 755 jasypt

cd jasypt
find . -type d | xargs chmod 755
find . -type f | xargs chmod 644
chmod 755 bin/*.sh
