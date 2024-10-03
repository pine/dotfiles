tasks_script_install() {
  local script
  local scripts="$DOTFILES_CONFIG/script/files.conf"
  local secured_scripts="$DOTFILES_SECURED_CONFIG/script/files.conf"

  _script_run_scripts "$DOTFILES_RESOURCES" "$scripts" 'script conf'
  _script_run_scripts "$DOTFILES_SECURED_RESOURCES" "$secured_scripts" 'secure script conf'
  _script_run_scripts "$CORPORATE_RESOURCES_DIR" "$CORPORATE_CONFIG_DIR/script/files.conf" 'corporate script conf'
}

_script_run_scripts() {
  local resources_dir=$1
  local conf_path=$2
  local conf_description=$3

  echo -n "Checking if $conf_description exists ... "
  if [ -f "$conf_path" ]; then
    echo 'yes'

    while read -u 9 script; do
      if [ -z "$script" ]; then
        continue
      fi
      if [ "${script:0:1}" = "#" ]; then
        continue
      fi

      _script_run_script "$resources_dir" "$script"
    done 9< "$conf_path"
  else
    echo 'no'
  fi
}

_script_run_script() {
  local resources_dir="$1"
  local script="$2"

  local fullpath="$resources_dir/script/$script.sh"
  if [ -e "$fullpath" ]; then
    echo "Running ${script}.sh"
    ENV_NAME=$(env_name) "$fullpath"
  fi
}
