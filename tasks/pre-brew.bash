# Setup Homebrew
tasks_brew_preinstall() {
  if env_is_macos; then
    _brew_init
    _brew_update
    _brew_taps
    _brew_update
    _brew_upgrade
  fi
}


_brew_init() {
  local name
  local tmp_dir
  local install_script_path

  if ! type -p brew > /dev/null 2>&1; then
    tmp_dir="$DF_TMP_DIR/pre-brew"
    install_script_path="$tmp_dir/install.sh"
    mkdir -p "$tmp_dir"

    curl -sL 'https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh' -o "$install_script_path"
    chmod +x "$install_script_path"
    "$install_script_path"
  fi

  for name in Caskroom Cellar Frameworks etc include lib opt sbin var; do
    if [ ! -d "/usr/local/$name" ]; then
      sudo mkdir "/usr/local/$name"
    fi
    if [ "$(stat -f "%Su" "/usr/local/$name")" != "$(whoami)" ]; then
      sudo chown -R "$(whoami)" "/usr/local/$name"
    fi
  done
}


_brew_update() {
  local config_path="$DF_CONFIG_DIR/brew/options.yml"
  local update=$(cat "$config_path" | "$YQ_PATH" '.update')

  if [[ "$update" == 'true' ]]; then
    echo 'Updating Homebrew ...'
    brew update || brew update
  else
    echo 'Skip Homebrew updates ...'
  fi
}


_brew_upgrade() {
  local config_path="$DF_CONFIG_DIR/brew/options.yml"
  local upgrade=$(cat "$config_path" | "$YQ_PATH" '.upgrade')

  if [[ "$upgrade" == 'true' ]]; then
    echo 'Upgrading Homebrew ...'
    brew upgrade || brew upgrade
  else
    echo 'Skip Homebrew upgrades ...'
  fi
}


_brew_taps() {
  local installed_taps="$(brew tap | tr ' ' "\n")"
  local config_path="$DF_CONFIG_DIR/brew/taps.yml"
  local tap

  cat "$config_path" | "$YQ_PATH" '.[]' | while read tap; do
    echo -n "Checking if $tap is tapped ..."

    if echo "$installed_taps" | fgrep "$tap" > /dev/null; then
      echo yes
    else
      echo no
      echo "Tapping $tap"
      brew tap "$tap"
    fi
  done

  echo 'Repairing taps ...'
  brew tap --repair
}
