env_name() {
  if [ "$USER" = 'kazuki-matsushita' ]; then
    echo 'company'
  else
    echo 'personal'
  fi
}

env_is_macos() {
  [ $ENV_OS = 'darwin' ]
}

# Moved from bin/install.sh so bash tasks can use them under the
# Python orchestrator (they are sourced together with the tasks).
is-macos() {
  uname -a | fgrep -i Darwin > /dev/null
}

has-apt() {
  type -p apt > /dev/null
}
