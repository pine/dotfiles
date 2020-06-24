# ~/.config/fish/conf.d/nodenv.fish

if test -d ~/.anyenv/envs/nodenv/bin
  set -x NODENV_ROOT "$HOME/.anyenv/envs/nodenv"
  set -x PATH $PATH "$NODENV_ROOT/bin"

  status --is-interactive; and nodenv init - | source
end
