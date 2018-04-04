# ~/.config/fish/conf.d/pyenv.fish

if test -d ~/.anyenv/envs/pyenv
  set -x PYENV_ROOT "$HOME/.anyenv/envs/pyenv"
  set -x PATH "$PYENV_ROOT/bin" $PATH
  status --is-interactive; and . (pyenv init - | psub)
end