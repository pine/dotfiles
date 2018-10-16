# ~/.config/fish/conf.d/goenv.fish

if test -d ~/.anyenv/envs/goenv
  set -x GOENV_ROOT "$HOME/.anyenv/envs/goenv"
  set -x PATH "$GOENV_ROOT/bin" $PATH

  set -gx PATH "$GOENV_ROOT/shims" $PATH
  set -gx GOENV_SHELL fish
  command goenv rehash 2>/dev/null
  function goenv
    set command $argv[1]
      set -e argv[1]

      switch "$command"
      case rehash
      case shell
          eval (goenv sh-"$command" $argv | psub)
      case '*'
          command goenv "$command" $argv
      end
  end
end

