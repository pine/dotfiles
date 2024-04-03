env_current() {
  if [ "$USER" = 'kazuki.matsushita' ]; then
    echo 'company'
  else
    echo 'personal'
  fi
}
