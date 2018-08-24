#!/bin/bash

set -eu -o pipefail

# -------------------------------------------------------------------

export LANG=en_US.UTF8
export LANGUAGE=en_US.UTF8
export LC_ALL=en_US.UTF8

# -------------------------------------------------------------------

declare -r DOTFILES_ROOT="$(cd ${BASH_SOURCE%/*}/..; pwd)"
cd "$DOTFILES_ROOT"

declare -r DOTFILES_CONFIG="$DOTFILES_ROOT/config"
declare -r DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"
declare -r DOTFILES_TASKS="$DOTFILES_ROOT/tasks"
declare -r DOTFILES_SECURED_ROOT="$DOTFILES_ROOT/secured"
declare -r DOTFILES_SECURED_CONFIG="$DOTFILES_SECURED_ROOT/config"
declare -r DOTFILES_SECURED_RESOURCES="$DOTFILES_SECURED_ROOT/resources"
declare -r DOTFILES_SECURED_TASKS="$DOTFILES_SECURED_ROOT/tasks"

# -------------------------------------------------------------------
# TODO: export functions

is-macos() {
  uname -a | fgrep -i Darwin > /dev/null
}

has-apt() {
  type -p apt > /dev/null
}

# -------------------------------------------------------------------

dotfiles_install() {
  local tasks
  local -i begin_at=$(date +%s)
  local -i end_at

  # Show system information
  _dotfiles_show_sys_info

  # Process secured dotfiles
  _dotfiles_extract_secured_zip

  # Run tasks
  tasks=$(_dotfiles_construct_tasks $*)
  _dotfiles_load_tasks
  _dotfiles_execute_tasks $tasks

  end_at=$(date +%s)
  printf "\n\e[32msuccess\e[39m\n"
  printf "\xe2\x9c\xa8  Done in $(($end_at - $begin_at))s.\n"
}


_dotfiles_show_sys_info() {
  echo "SysInfo: $(uname -mnrs)"
  echo "SysInfo: bash v$BASH_VERSION"
}


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


_dotfiles_construct_tasks() {
  local tasks

  if [ -n "$*" ]; then
    tasks=$*
  else
    tasks=$(cat "$DOTFILES_CONFIG/tasks")
    if [ -r "$DOTFILES_SECURED_CONFIG/tasks" ]; then
      tasks=$tasks$'\n'$(cat "$DOTFILES_SECURED_CONFIG/tasks")
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

  for task in $tasks; do
    if [ -z "$task" ]; then
      continue
    fi
    for action in preinstall install postinstall; do
      if type "${task}_$action" &> /dev/null; then
        echo "Running: ${task}_$action"
        "${task}_$action"
      fi
    done
  done
}


dotfiles_install $*
