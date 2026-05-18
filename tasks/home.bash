
tasks_home_install() {
  _tasks_home_install "$DF_CONFIG_DIR" "$DF_RESOURCES_DIR"
  _tasks_home_install "$DF_SECURE_CONFIG_DIR" "$DF_SECURE_RESOURCES_DIR"
  _tasks_home_install "$DF_CORPORATE_CONFIG_DIR" "$DF_CORPORATE_RESOURCES_DIR"
}

_tasks_home_install() {
  local config_dir="$1"
  local resources_dir="$2"
  local config_file="$config_dir/home/files.yml"
  local path

  if [ ! -f "$config_file" ]; then
    return 0
  fi

  cat "$config_file" | "$YQ_PATH" '.[]' -o=json -I=0 | while read file_json; do
    _tasks_home_install_file "$resources_dir" "$file_json"
  done
}

_tasks_home_install_file() {
  local resources="$1"
  local file_json="$2"

  local path=$(echo $file_json | "$YQ_PATH" '.path')
  local strategy=$(echo $file_json | "$YQ_PATH" '.strategy // ""')

  if [ -z "$path" ]; then
    return
  fi

  local src="$resources/home/$path"
  local dest="$HOME/$path"
  local dest_dir="${dest%/*}"

  mkdir -p "$dest_dir"

  if [ "$strategy" = "copy" ]; then
    echo "> cp $src $dest"
    rm -f "$HOME/$path"
    cp "$src" "$HOME/$path"
    chmod 600 "$HOME/$path" # XXX
  else
    echo "> ln -s $src $dest"
    rm -f "$HOME/$path"
    ln -s "$src" "$HOME/$path"
  fi
}
