# tasks/pref.bash


pref_install() {
  if is-macos; then
    _pref_install_macos
  fi
}


_pref_install_macos() {
  local script="$DOTFILES_RESOURCES/pref/prefs.scpt"
  echo "> osascript $script"
  osascript "$script"
}
