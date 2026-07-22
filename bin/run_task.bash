#!/bin/bash
#
# Thin runner shim invoked once per (task, action) by the Python orchestrator.
#
# It reproduces exactly what the old install.sh did in-process: source the init
# scripts, the shared functions, and every task file (repo + secured), then call
# `tasks_<task>_<action>` if it is defined. No state is cached between calls --
# init/functions/tasks are re-sourced on every invocation by design.
#
# All DF_* / DOTFILES_* path variables are provided by the caller via the
# environment.

set -eu -o pipefail

task="$1"
action="$2"

# init scripts (env detection, yq install, secured extraction), sorted.
for _f in $(find "$DF_INIT_DIR" -type f -name "*.bash" | sort); do
  # shellcheck disable=SC1090
  . "$_f"
done

# shared functions (config parser, env helpers, is-macos/has-apt).
for _f in $(find "$DF_FUNC_DIR" -type f -name "*.bash"); do
  # shellcheck disable=SC1090
  . "$_f"
done

# task definitions (repo).
for _f in $(find "$DOTFILES_TASKS" -type f -name "*.bash"); do
  # shellcheck disable=SC1090
  . "$_f"
done

# task definitions (secured submodule), if present.
if [ -n "${DOTFILES_SECURED_TASKS:-}" ] && [ -d "$DOTFILES_SECURED_TASKS" ]; then
  for _f in $(find "$DOTFILES_SECURED_TASKS" -type f -name "*.bash"); do
    # shellcheck disable=SC1090
    . "$_f"
  done
fi

fn="tasks_${task}_${action}"
if type "$fn" &> /dev/null; then
  echo "Running: $fn"
  cd "$DF_ROOT_DIR"
  "$fn"
fi
