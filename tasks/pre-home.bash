# Prepare home directory

tasks_home_preinstall() {
  _tasks_home_create_directories
}

_tasks_home_create_directories() {
  local config_path="$DF_CONFIG/home/directories.yml"

  cat "$config_path" | "$YQ_PATH" '.[]' | while read directory; do
    echo -n "Checking if ~/$directory exists ..."

    if [ -d "$HOME/$directory" ]; then
      echo 'yes'
    else
      echo 'no'

      echo "Creating directory ~/$directory"
      mkdir -p "$HOME/$directory"
    fi
  done
}
