# Install and update each env in anyenv

tasks_anyenv_install() {
  local config_path="$DOTFILES_CONFIG/anyenv.yml"
  local env_json
  local env_name
  local plugin_json
  local plugin_name
  local plugin_uri

  "$YQ_PATH" e '.[]' -o=json -I=0 "$config_path" | while read env_json; do
    env_name=$(echo "$env_json" | $YQ_PATH '.name')

    _anyenv_install_env "$env_name"
    _anyenv_update_env "$env_name"

    echo "$env_json" | "$YQ_PATH" '.plugins[]' -o=json -I=0 | while read plugin_json; do
      plugin_name=$(echo "$plugin_json" | "$YQ_PATH" '.name')
      plugin_uri=$(echo "$plugin_json" | "$YQ_PATH" '.uri')

      _anyenv_install_plugin "$env_name" "$plugin_name" "$plugin_uri"
      _anyenv_update_plugin "$env_name" "$plugin_name" "$plugin_uri"
    done
  done
}

# Install env
_anyenv_install_env() {
  local name=$1

  echo "Installing $name ..."
  anyenv install -s "$name"
}


# Update env
_anyenv_update_env() {
  local name=$1
  local branch_name

  echo "Updating $name ..."

  pushd "$HOME/.anyenv/envs/$name"
  branch_name=$(git rev-parse --abbrev-ref HEAD)
  git pull origin "$branch_name"
  popd > /dev/null
}


# Install plugin
_anyenv_install_plugin() {
  local env_name=$1
  local plugin_name=$2
  local plugin_uri=$3
  local path="$HOME/.anyenv/envs/$env_name/plugins/$plugin_name"

  echo -n "Checking if $plugin_name is installed ... "
  if [ -d "$path" ]; then
    echo yes
  else
    echo no
    git clone "$plugin_uri" "$path"
  fi
}


# Update plugins
_anyenv_update_plugin() {
  local env_name=$1
  local plugin_name=$2
  local plugin_uri=$3
  local path="$HOME/.anyenv/envs/$env_name/plugins/$plugin_name"
  local branch_name

  echo "Updateing $plugin_name ..."

  pushd "$path"
  branch_name=$(git rev-parse --abbrev-ref HEAD)
  git pull origin "$branch_name"
  popd > /dev/null
}
