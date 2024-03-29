# ~/.config/fish/conf.d/pyenv.fish

set -x PYTHON_CONFIGURE_OPTS "--enable-shared"

if test -d ~/.anyenv/envs/pyenv
  set -x PYENV_ROOT "$HOME/.anyenv/envs/pyenv"
  set -x PATH "$PYENV_ROOT/bin" $PATH
  status is-login; and pyenv init --path | source
  pyenv init - | source
end
