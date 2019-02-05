
if test -d "$HOME/.anyenv/envs/nodenv/bin"
  set -x NODENV_ROOT "$HOME/.anyenv/envs/nodenv"
  set -x PATH $PATH "$HOME/.anyenv/envs/nodenv/bin"
  set -gx PATH "$HOME/.anyenv/envs/nodenv/shims" $PATH
  set -gx NODENV_SHELL fish
  source "$HOME/.anyenv/envs/nodenv/completions/nodenv.fish"
  command nodenv rehash 2>/dev/null
  function nodenv
    set command $argv[1]
    set -e argv[1]

    switch "$command"
    case rehash shell
      source (nodenv "sh-$command" $argv|psub)
    case '*'
      command nodenv "$command" $argv
    end
  end
end
