env_name() {
  if [ "$USER" = 'kazuki.matsushita' ]; then
    echo 'company'
  else
    echo 'personal'
  fi
}

env_is_macos() {
  [ $ENV_OS = 'darwin' ]
}
