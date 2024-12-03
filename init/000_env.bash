# Setup environment variables

case "$OSTYPE" in
  linux-gnu*)
    declare -r DF_OS=linux;;
  darwin*)
    declare -r DF_OS=darwin;;
  *)
    echo "ERROR! Unsupported OS : $OSTYPE" >&2
    exit 1;;
esac

case "$(uname -m)" in
  x86_64|amd64)
    declare -r DF_ARCH=amd64;;
  arm64)
    declare -r DF_ARCH=arm64;;
  *)
    echo "ERROR! Unsupported processor : $(uname -m)" >&2
    exit 1;;
esac

echo "DF_OS: $DF_OS"
echo "DF_ARCH: $DF_ARCH"
