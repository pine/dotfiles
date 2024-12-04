# Setup environment variables

case "$OSTYPE" in
  linux-gnu*)
    declare -r ENV_OS=linux;;
  darwin*)
    declare -r ENV_OS=darwin;;
  *)
    echo "ERROR! Unsupported OS : $OSTYPE" >&2
    exit 1;;
esac

case "$(uname -m)" in
  x86_64|amd64)
    declare -r ENV_ARCH=amd64;;
  arm64)
    declare -r ENV_ARCH=arm64;;
  *)
    echo "ERROR! Unsupported processor : $(uname -m)" >&2
    exit 1;;
esac

echo "ENV_OS: $ENV_OS"
echo "ENV_ARCH: $ENV_ARCH"
