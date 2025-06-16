# Secure repository preparation

init_secure_install() {
  _init_secure_extract_zip
}

_init_secure_extract_zip() {
  local zip_fname="dotfiles.secured-master.zip"
  local dir="dotfiles.secured-master"

  if [ -f "$DOTFILES_SECURED_ROOT/README.md" ]; then
    return
  fi

  if [ -r "$DF_ROOT_DIR/$zip_fname" ]; then
    rm -rf "$DF_ROOT_DIR/$dir"
    rm -rf "$DOTFILES_SECURED_ROOT"
    unzip "$zip_fname"
    mv "$dir" "$DOTFILES_SECURED_ROOT"
  fi
}

init_secure_install
