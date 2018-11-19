# tasks/pref.bash


pref_install() {
  if is-macos; then
    _pref_install_macos_osascript
    _pref_install_macos_defaults
  fi
}


_pref_install_macos_osascript() {
  local script="$DOTFILES_RESOURCES/pref/prefs.scpt"
  echo "> osascript $script"
  osascript "$script"
}


_pref_install_macos_defaults() {
  local defaults="$DOTFILES_RESOURCES/pref/defaults.sh"
  echo "> $defaults"
  "$defaults"
}
