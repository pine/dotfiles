#!/bin/bash

set -eu -o pipefail

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# -------------------------------------------------------------------
# Setup global variables
# -------------------------------------------------------------------

declare -r DOTFILES_ROOT="$(cd ${BASH_SOURCE%/*}/..; pwd)"
cd "$DOTFILES_ROOT"

declare -r DOTFILES_CONFIG="$DOTFILES_ROOT/config"
declare -r DOTFILES_FUNCTIONS="$DOTFILES_ROOT/functions"
declare -r DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"
declare -r DOTFILES_TASKS="$DOTFILES_ROOT/tasks"
declare -r DOTFILES_SECURED_ROOT="$DOTFILES_ROOT/secured"
declare -r DOTFILES_SECURED_CONFIG="$DOTFILES_SECURED_ROOT/config"
declare -r DOTFILES_SECURED_RESOURCES="$DOTFILES_SECURED_ROOT/resources"
declare -r DOTFILES_SECURED_TASKS="$DOTFILES_SECURED_ROOT/tasks"

declare -r DF_INIT_DIR="$DOTFILES_ROOT/init"
declare -r DF_VENDOR_DIR="$DOTFILES_ROOT/vendor"

# Corporate
declare -r CORPORATE_DIR="$HOME/project/kazuki-matsushita/dotfiles-corporate"
declare -r CORPORATE_CONFIG_DIR="$CORPORATE_DIR/config"
declare -r CORPORATE_RESOURCES_DIR="$CORPORATE_DIR/resources"


# -------------------------------------------------------------------
# TODO: export functions

is-macos() {
  uname -a | fgrep -i Darwin > /dev/null
}

has-apt() {
  type -p apt > /dev/null
}

# -------------------------------------------------------------------

_dotfiles_extract_secured_zip() {
  local zip_fname="dotfiles.secured-master.zip"
  local dir="dotfiles.secured-master"

  if [ -f "$DOTFILES_SECURED_ROOT/README.md" ]; then
    return
  fi

  if [ -r "$DOTFILES_ROOT/$zip_fname" ]; then
    rm -rf "$DOTFILES_ROOT/$dir"
    rm -rf "$DOTFILES_SECURED_ROOT"
    unzip "$zip_fname"
    mv "$dir" "$DOTFILES_SECURED_ROOT"
  fi
}


_dotfiles_import_functions() {
  local file

  for file in $(find "$DOTFILES_FUNCTIONS" -type f -name "*.bash"); do
    echo "Importing $file"
    . $file
  done
}


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
        $func
      fi
    done
  done
}


# -------------------------------------------------------------------

declare _TASKS
declare -i _INSTALL_BEGIN_AT=$(date +%s)
declare -i _INSTALL_END_AT

# -------------------------------------------------------------------
# Import init scripts
# -------------------------------------------------------------------

declare _SCRIPT_PATH
declare _SCRIPT_RELATIVE_PATH

for _SCRIPT_PATH in $(find "$DF_INIT_DIR" -type f -name "*.bash" | sort); do
  _SCRIPT_RELATIVE_PATH=$(echo $_SCRIPT_PATH | sed -e "s@^$DOTFILES_ROOT@\.@")
  echo "Running $_SCRIPT_RELATIVE_PATH"
  . $_SCRIPT_PATH
done

unset -v _SCRIPT_PATH
unset -v _SCRIPT_RELATIVE_PATH


# Process secured dotfiles
_dotfiles_extract_secured_zip

# Import functions
_dotfiles_import_functions

# Run tasks
_TASKS=$(_dotfiles_construct_tasks $*)
_dotfiles_load_tasks
_dotfiles_execute_tasks $_TASKS

_INSTALL_END_AT=$(date +%s)
printf "\n\e[32msuccess\e[39m\n"
printf "\xe2\x9c\xa8  Done in $(($_INSTALL_END_AT - $_INSTALL_BEGIN_AT))s.\n"
