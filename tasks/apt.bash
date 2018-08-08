# tasks/apt.bash

apt_install() {
  if ! is-macos && has-apt; then
    :
  fi
}
