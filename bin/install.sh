#!/bin/bash
#
# Entry point. The orchestration lives in the `df` Python package (run via uv);
# this wrapper vendors uv into vendor/uv/ (like init/001_yq.bash does for yq),
# then hands off. Individual tasks are still bash (see bin/run_task.bash).
#
#   ./bin/install.sh            # run all tasks from config/tasks.conf
#   ./bin/install.sh brew home  # run only the named tasks

set -eu -o pipefail

# Pinned uv version. Bump to upgrade.
readonly UV_VERSION=0.11.31

DF_ROOT_DIR="$(cd "${BASH_SOURCE%/*}/.."; pwd)"
cd "$DF_ROOT_DIR"

readonly VENDOR_DIR="$DF_ROOT_DIR/vendor"
readonly UV_BIN="$VENDOR_DIR/uv"

# Only macOS on Apple Silicon is supported (Linux/x86_64 are out of scope).
readonly UV_TARGET=aarch64-apple-darwin

if [ "$(uname -s)" != Darwin ] || [ "$(uname -m)" != arm64 ]; then
  echo "ERROR! Unsupported platform: $(uname -s) $(uname -m) (only macOS arm64 is supported)" >&2
  exit 1
fi

_uv_installed() {
  echo -n 'Checking if uv is installed ... '
  if [ ! -x "$UV_BIN" ]; then
    echo no
    return 1
  fi

  local current
  current=$("$UV_BIN" --version 2>/dev/null | grep -o -E '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
  if [ "$current" != "$UV_VERSION" ]; then
    echo no
    return 1
  fi

  echo yes
  return 0
}

_uv_install() {
  local tarball url tmpdir
  tarball="uv-${UV_TARGET}.tar.gz"
  url="https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/${tarball}"
  tmpdir=$(mktemp -d)

  echo "Installing uv ${UV_VERSION} ..."
  curl -fL "$url" -o "$tmpdir/$tarball"
  tar -xzf "$tmpdir/$tarball" -C "$tmpdir"

  mkdir -p "$VENDOR_DIR"
  cp -f "$tmpdir/uv-${UV_TARGET}/uv" "$UV_BIN"
  chmod +x "$UV_BIN"

  rm -rf "$tmpdir"
  echo 'Successfully installed'
}

if ! _uv_installed; then
  _uv_install
fi

exec "$UV_BIN" run --quiet python -m df "$@"
