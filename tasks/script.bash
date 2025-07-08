tasks_script_install() {
  local config_path="$DF_CONFIG_DIR/script/files.yml"
  local secured_scripts="$DOTFILES_SECURED_CONFIG/script/files.conf"
  local corporate_config_path="$DF_CORPORATE_CONFIG_DIR/script/files.yml"

  _script_run_scripts "$DOTFILES_RESOURCES" "$config_path" 'main'
  _script_run_scripts "$DOTFILES_SECURED_RESOURCES" "$secured_scripts" 'secure script conf'
  _script_run_scripts "$DF_CORPORATE_RESOURCES_DIR" "$corporate_config_path" 'corporate'
}


_script_run_scripts() {
  local resources_dir=$1
  local config_path=$2
  local repository=$3
  local script_name

  echo -n "Checking if $repository config exists ... "
  if [ -f "$config_path" ]; then
    echo 'yes'

    cat "$config_path" | "$YQ_PATH" '.[]' -o=j -I=0 | while read script; do
      script_name=$(echo "$script" | "$YQ_PATH" '.name')
      _script_run_script "$resources_dir" "$script_name"
    done
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
