#!/bin/bash

set -eu -o pipefail

# -------------------------------------------------------------------

declare -r DOTFILES_ROOT="$(cd ${BASH_SOURCE%/*}/..; pwd)"
cd "$DOTFILES_ROOT"

declare -r DOTFILES_CONFIG="$DOTFILES_ROOT/config"
declare -r DOTFILES_RESOURCE="$DOTFILES_ROOT/resources"
declare -r DOTFILES_TASKS="$DOTFILES_ROOT/tasks"
declare -r DOTFILES_SECURED_CONFIG="$DOTFILES_ROOT/secured/config"
declare -r DOTFILES_SECURED_RESOURCES="$DOTFILES_ROOT/secured/resources"
declare -r DOTFILES_SECURED_TASKS="$DOTFILES_ROOT/secured/tasks"

# -------------------------------------------------------------------

install() {
  local action
  local file
  local task
  local tasks
  local -i begin_at=$(date +%s)
  local -i end_at

  # Create task list
  if [ -n "$*" ]; then
    tasks=$*
  else
    tasks=$(cat "$DOTFILES_CONFIG/tasks")
    if [ -r "$DOTFILES_SECURED_CONFIG/tasks" ]; then
      tasks=$tasks$'\n'$(cat "$DOTFILES_SECURED_CONFIG/tasks")
    fi
  fi

  # Load task files
  for file in $(find "$DOTFILES_TASKS" -type f -name "*.bash"); do
    echo "Loading \`$file\`"
    . $file
  done
  if [ -d "$DOTFILES_SECURED_TASKS" ]; then
    for file in $(find "$DOTFILES_SECURED_TASKS" -type f -name "*.bash"); do
      echo "Loading \`$file\`"
      . $file
    done
  fi

  # Execute tasks
  for task in $tasks; do
    if [ -z "$task" ]; then
      continue
    fi
    for action in preinstall install postinstall; do
      if type "${task}_$action" &> /dev/null; then
        echo "Running \`${task}_$action\`"
        "${task}_$action"
      fi
    done
  done

  end_at=$(date +%s)
  printf "\e[32msuccess\e[39m\n"
  printf "\xe2\x9c\xa8  Done in $(($end_at - $begin_at))s.\n"
}

install $*
