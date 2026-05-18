# Prepare home directory

tasks_home_preinstall() {
  _tasks_home_create_directories "$DF_CONFIG_DIR"
  _tasks_home_create_directories "$DF_SECURE_CONFIG_DIR"
  _tasks_home_create_directories "$DF_CORPORATE_CONFIG_DIR"
}

_tasks_home_create_directories() {
  local config_dir=$1
  local config_file="$config_dir/home/directories.yml"
  local path
  local mode

  if [ ! -f "$config_file" ]; then
    return 0
  fi

  cat "$config_file" | "$YQ_PATH" '.[]' -o=json -I=0 | while read directory; do
    path=$(echo "$directory" | "$YQ_PATH" '.path')
    mode=$(echo "$directory" | "$YQ_PATH" '.mode // ""')

    echo -n "Checking if ~/$path exists ..."
    if [ -d "$HOME/$path" ]; then
      echo 'yes'
    else
      echo 'no'
      echo "Creating directory ~/$path"
      mkdir -p "$HOME/$path"
    fi

    if [ -n "$mode" ]; then
      echo -n "Checking if the permissions of ~/$path are $mode ... "
      if [ "$mode" == $(stat -f '%Lp' "$HOME/$path") ]; then
        echo yes
      else
        echo no
        echo "Change the permissions of ~/$path to $mode"
        chmod "$mode" "$HOME/$path"
      fi
    fi
  done
}
