#!/bin/bash

set -eu -o pipefail


# -------------------------------------------------------------------
# Start installing
# -------------------------------------------------------------------

echo 'Started installing'

declare -i _INSTALL_BEGIN_AT=$(date +%s)
declare -i _INSTALL_END_AT


# -------------------------------------------------------------------
# Setup global environment variables
# -------------------------------------------------------------------

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# -------------------------------------------------------------------
# Setup global variables
# -------------------------------------------------------------------

# Move to root directory
declare -r DF_ROOT="$(cd ${BASH_SOURCE%/*}/..; pwd)"
cd "$DF_ROOT"

# Create temporary directory
declare -r DF_TMP_DIR=$(mktemp -d)
trap "rm -rf $DF_TMP_DIR" EXIT

declare -r DOTFILES_CONFIG="$DF_ROOT/config" # deprecated
declare -r DOTFILES_RESOURCES="$DF_ROOT/resources"
declare -r DOTFILES_TASKS="$DF_ROOT/tasks"
declare -r DF_CONFIG="$DF_ROOT/config"
declare -r DF_FUNC_DIR="$DF_ROOT/functions"
declare -r DF_INIT_DIR="$DF_ROOT/init"
declare -r DF_VENDOR_DIR="$DF_ROOT/vendor"

# Secure
declare -r DOTFILES_SECURED_ROOT="$DF_ROOT/secured" # deprecated
declare -r DOTFILES_SECURED_CONFIG="$DOTFILES_SECURED_ROOT/config" # deprecated
declare -r DOTFILES_SECURED_RESOURCES="$DOTFILES_SECURED_ROOT/resources" # deprecated
declare -r DOTFILES_SECURED_TASKS="$DOTFILES_SECURED_ROOT/tasks"
declare -r DF_SECURE_ROOT_DIR="$DF_ROOT/secured"
declare -r DF_SECURE_CONFIG_DIR="$DF_SECURE_ROOT_DIR/config"
declare -r DF_SECURE_RESOURCES_DIR="$DF_SECURE_ROOT_DIR/resources"

# Corporate
declare -r CORPORATE_DIR="$HOME/project/kazuki-matsushita/dotfiles-corporate" # deprecated
declare -r DF_CORPORATE_DIR="$HOME/project/kazuki-matsushita/dotfiles-corporate"
declare -r DF_CORPORATE_CONFIG_DIR="$DF_CORPORATE_DIR/config"
declare -r DF_CORPORATE_RESOURCES_DIR="$DF_CORPORATE_DIR/resources"

# Print variables
echo "DF_ROOT: $DF_ROOT"
echo "DF_TMP_DIR: $DF_TMP_DIR"

# -------------------------------------------------------------------
# TODO: export functions

is-macos() {
  uname -a | fgrep -i Darwin > /dev/null
}

has-apt() {
  type -p apt > /dev/null
}

# -------------------------------------------------------------------


_dotfiles_construct_tasks() {
  local tasks

  if [ -n "$*" ]; then
    tasks=$*
  else
    tasks=$(cat "$DOTFILES_CONFIG/tasks.conf")
    if [ -r "$DOTFILES_SECURED_CONFIG/tasks.conf" ]; then
      tasks=$tasks$'\n'$(cat "$DOTFILES_SECURED_CONFIG/tasks.conf")
    fi
  fi

  echo $tasks
}


_dotfiles_load_tasks() {
  local file

  for file in $(find "$DOTFILES_TASKS" -type f -name "*.bash"); do
    echo "Loading: $file"
    . $file
  done

  if [ -d "$DOTFILES_SECURED_TASKS" ]; then
    for file in $(find "$DOTFILES_SECURED_TASKS" -type f -name "*.bash"); do
      echo "Loading: $file"
      . $file
    done
  fi
}


_dotfiles_execute_tasks() {
  local action
  local task
  local tasks=$*
  local func

  for task in $tasks; do
    if [ "${task:0:1}" == "#" ]; then
      continue
    fi
    if [ -z "$task" ]; then
      continue
    fi
    for action in preinstall install postinstall; do
      if type "tasks_${task}_$action" &> /dev/null; then
        echo "Running: tasks_${task}_$action"

        func="tasks_${task}_$action"
        pushd "$DF_ROOT" > /dev/null
        $func
        popd > /dev/null
      fi
    done
  done
}


# -------------------------------------------------------------------
# Import init scripts
# -------------------------------------------------------------------

declare _SCRIPT_PATH
declare _SCRIPT_RELATIVE_PATH

for _SCRIPT_PATH in $(find "$DF_INIT_DIR" -type f -name "*.bash" | sort); do
  _SCRIPT_RELATIVE_PATH=$(echo $_SCRIPT_PATH | sed -e "s@^$DF_ROOT@\.@")
  echo "Loading: $_SCRIPT_RELATIVE_PATH"

  pushd "$DF_ROOT" > /dev/null
  . "$_SCRIPT_PATH"
  popd > /dev/null
done

unset -v _SCRIPT_PATH
unset -v _SCRIPT_RELATIVE_PATH

# -------------------------------------------------------------------
# Import functions
# -------------------------------------------------------------------

declare _FUNC_PATH
declare _FUNC_RELATIVE_PATH

for _FUNC_PATH in $(find "$DF_FUNC_DIR" -type f -name "*.bash"); do
  _FUNC_RELATIVE_PATH=$(echo $_FUNC_PATH | sed -e "s@^$DF_ROOT@\.@")
  echo "Loading: $_FUNC_RELATIVE_PATH"

  pushd "$DF_ROOT" > /dev/null
  . "$_FUNC_PATH"
  popd > /dev/null
done

unset -v _FUNC_PATH
unset -v _FUNC_RELATIVE_PATH

# -------------------------------------------------------------------

# Run tasks
declare _TASKS
_TASKS=$(_dotfiles_construct_tasks $*)
_dotfiles_load_tasks
_dotfiles_execute_tasks $_TASKS

_INSTALL_END_AT=$(date +%s)
printf "\n\e[32msuccess\e[39m\n"
printf "\xe2\x9c\xa8  Done in $(($_INSTALL_END_AT - $_INSTALL_BEGIN_AT))s.\n"
