# tasks/fish.bash

tasks_fish_install() {
  if type -p fish > /dev/null; then
    _fish_install_fisher

    if [ -z "${CI:-}" ]; then
      _fish_set_default_shell
    fi
  fi
}


_fish_install_fisher() {
  echo -n 'Checking if fisher is installed ... '
  if [ -f "$HOME/.config/fish/functions/fisher.fish" ]; then
    echo 'yes'
  else
    echo 'no'
    curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
  fi

  echo 'Checking fisher version'
  fish --login -c 'fisher -v'
  echo 'Updating fisher plugins'
  fish --login -c 'fisher update'
}


_fish_set_default_shell() {
  local homebrew_prefix=$(brew --prefix)

  if is-macos; then
    if ! fgrep "$homebrew_prefix/bin/fish" /etc/shells > /dev/null; then
      echo "$homebrew_prefix/bin/fish" | sudo tee -a /etc/shells > /dev/null
    fi

    sh=$(dscl . -read "/Users/$(whoami)" UserShell)
    if ! echo "$sh" | fgrep "$homebrew_prefix/bin/fish" > /dev/null; then
      chsh -s "$homebrew_prefix/bin/fish"
    fi
  fi
}
