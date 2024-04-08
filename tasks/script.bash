# tasks/script.bash

tasks_script_install() {
  local script
  local scripts="$DOTFILES_CONFIG/script/files.conf"
  local secured_scripts="$DOTFILES_SECURED_CONFIG/script/files.conf"

  while read -u 9 script; do
    _script_run_script "$DOTFILES_RESOURCES" "$script"
  done 9< "$scripts"

  if [ -f "$secured_scripts" ]; then
    while read -u 9 script; do
      _script_run_script "$DOTFILES_SECURED_RESOURCES" "$script"
    done 9< "$secured_scripts"
  fi
}

_script_run_script() {
  local resources="$1"
  local script="$2"

  if [ -z "$script" ]; then
    continue
  fi
  if [ "${script:0:1}" = "#" ]; then
    continue
  fi

  local fullpath="$resources/script/$script.sh"
  if [ -e "$fullpath" ]; then
    echo "> $fullpath"
    ENV_NAME=$(env_name) "$fullpath"
  fi
}
