env_name() {
  if [ "$USER" = 'kazuki.matsushita' ]; then
    echo 'company'
  else
    echo 'personal'
  fi
}

export DOTFILES_ENV_NAME=$(env_name)
