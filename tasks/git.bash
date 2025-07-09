
tasks_git_install() {
  local corporate_config_path="$DF_CORPORATE_CONFIG_DIR/git.yml"
  _tasks_git_install "${corporate_config_path}"
}


_tasks_git_install() {
  local config_path="$1"
  local config_relative_path
  local uri
  local path
  local ignore_errors

  if [ ! -f $config_path ]; then
    config_relative_path=$(echo "$config_path" | sed -e "s@^$HOME@\~@")
    echo "INFO: $config_relative_path does not exists, so it was skipped"
    return
  fi

  cat "$config_path" | "$YQ_PATH" -o=json -I=0 '.repos.[]' | while read repo; do
    uri=$(echo "$repo" | "$YQ_PATH" '.uri')
    path=$(echo "$repo" | "$YQ_PATH" '.path')
    ignore_errors=$(echo "$repo" | "$YQ_PATH" '.ignore_errors // false')

    # Resolve ~ to $HOME
    realpath=${path/#\~/$HOME}

    echo -n "Checking if $path already exists ... "
    if [ -d "$realpath" ]; then
      echo yes
      return
    else
      echo no
    fi

    if ! git clone "$uri" "$realpath"; then
      echo "ERROR: Failed to clone $uri into $path" 1>&2
      if [ "$ignore_errors" != 'true' ]; then
        return 1
      fi
    fi
  done
}
