#!/bin/bash

anyenv_install() {
  _anyenv_install_envs
  _anyenv_install_plugins
  _anyenv_update_envs
}

# Install anvs
_anyenv_install_envs() {
  local env
  local envs="$DOTFILES_CONFIG/anyenv/envs.conf"

  cat "$envs" | while read env; do
    echo "> anyenv install -s $env"
    anyenv install -s $env
  done
}

# Install plugins
_anyenv_install_plugins() {
  local env
  local envs="$DOTFILES_CONFIG/anyenv/envs.conf"
  local name
  local plugin
  local plugins
  local repo_url
  local repo_path

  cat "$envs" | while read env; do
    if [ ! -d "$HOME/.anyenv/envs/$env" ]; then
      continue
    fi

    plugins="$DOTFILES_CONFIG/anyenv/plugins/$env.conf"
    if [ ! -r "$plugins" ]; then
      continue
    fi

    cat "$plugins" | while read plugin; do
      plugin="$(echo $plugin | tr '\t' ' ')"

      name=${plugin%% *}
      if [ -z "$name" ]; then
        continue
      fi

      repo_url=${plugin##* }
      if [ -z "$repo_url" ]; then
        continue
      fi

      repo_path="$HOME/.anyenv/envs/$env/plugins/$name"
      if [ ! -d "$repo_path" ]; then
        echo "> git clone $repo_url $repo_path"
        git clone "$repo_url" "$repo_path"
      fi
    done
  done
}

# Update envs
_anyenv_update_envs() {
  local env
  local envs="$DOTFILES_CONFIG/anyenv/envs.conf"

  cat "$envs" | while read env; do
    pushd "$HOME/.anyenv/envs/$env"
    git pull origin master
    popd
  done
}
