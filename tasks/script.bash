# tasks/script.bash

script_install() {
  local fullpath
  local script
  local scripts="$DOTFILES_CONFIG/script/files.conf"

  cat "$scripts" | while read script; do
    if [ -z "$script" ]; then
      continue
    fi
    if [ "${script:0:1}" = "#" ]; then
      continue
    fi

    fullpath="$DOTFILES_RESOURCES/script/$script.sh"
    if [ -e "$fullpath" ]; then
      echo "> $fullpath"
      "$fullpath"
    fi
  done
}
