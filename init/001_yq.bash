# Install yq command

declare -r YQ_VERSION=v4.44.5
declare -r YQ_URL="https://github.com/mikefarah/yq/releases/download/$YQ_VERSION/yq_${ENV_OS}_${ENV_ARCH}"
declare -r YQ_DIR="$DF_VENDOR_DIR/yq"
declare -r YQ_FILENAME="yq_${ENV_OS}_${ENV_ARCH}"
declare -r YQ_PATH="$YQ_DIR/$YQ_FILENAME"

# -------------------------------------------------------------------

init_yq_install() {
  _init_yq_printenv
  if _init_yq_exists; then
    return
  fi


  _init_yq_install
}

_init_yq_printenv() {
  echo "YQ_VERSION: $YQ_VERSION"
  echo "YQ_URL: $YQ_URL"
  echo "YQ_DIR: $YQ_DIR"
  echo "YQ_FILENAME: $YQ_FILENAME"
  echo "YQ_PATH: $YQ_PATH"
}


_init_yq_exists() {
  if [ ! -f "$YQ_PATH" ]; then
    return 1
  fi

  local current_version=$("$YQ_PATH" -V | grep -o -E ' v[0-9\.]+$' | tr -d '[:space:]')
  if [ "$YQ_VERSION" != "$current_version" ]; then
    return 1
  fi

  return 0
}

_init_yq_install() {
  local tmpdir=$(mktemp -d)
  cd $tmpdir

  curl -L "$YQ_URL" -o "$YQ_FILENAME"

  mkdir -p "$YQ_DIR"
  cp -f "$YQ_FILENAME" "$YQ_PATH"
  chmod +x "$YQ_PATH"

  rm -rf $tmpdir
}


init_yq_install
