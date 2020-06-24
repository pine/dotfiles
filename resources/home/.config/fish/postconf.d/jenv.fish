# ~/.config/fish/conf.d/jenv.fish

if test -d ~/.anyenv/envs/jenv
  set -x JENV_ROOT "$HOME/.anyenv/envs/jenv"
  set -x PATH "$JENV_ROOT/bin" $PATH
  status --is-interactive; and jenv init - | source
end
