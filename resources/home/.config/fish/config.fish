# ~/.config/fish/config.fish

set -g CDPATH .
test -d ~/project; and set -g CDPATH $CDPATH ~/project

begin
  set -l paths /sbin /usr/sbin /bin /usr/sbin \
    /usr/local/sbin /usr/local/bin \
    /usr/lib/dart/bin /usr/local/Homebrew/bin /usr/local/*/bin \
    $HOME/bin $HOME/bin/*/bin

  for p in $paths
    test -d $p; and set -x PATH $p $PATH
  end
end

set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8


# anyenv ----------------------------------------------------------------------

if test -d ~/.anyenv
  set -x PATH $HOME/.anyenv/bin $PATH
end

# rbenv
if test -d ~/.anyenv/envs/rbenv
  set -x RBENV_ROOT "$HOME/.anyenv/envs/rbenv"
  set -x PATH "$RBENV_ROOT/bin" $PATH
  status --is-interactive; and . (rbenv init - | psub)
end

# pyenv
if test -d ~/.anyenv/envs/pyenv
  set -x PYENV_ROOT "$HOME/.anyenv/envs/pyenv"
  set -x PATH "$PYENV_ROOT/bin" $PATH
  status --is-interactive; and . (pyenv init - | psub)
end

# plenv
if test -d ~/.anyenv/envs/plenv
  set -x PLENV_ROOT "$HOME/.anyenv/envs/plenv"
  set -x PATH "$PLENV_ROOT/bin" $PATH
  status --is-interactive; and . (plenv init - | psub)
end

# ndenv
if test -d ~/.anyenv/envs/ndenv
  set -x NDENV_ROOT "$HOME/.anyenv/envs/ndenv"
  set -x PATH "$NDENV_ROOT/bin" $PATH

  set -gx PATH "$NDENV_ROOT/shims" $PATH
  set -gx NDENV_SHELL fish
  command ndenv rehash 2>/dev/null
  function ndenv
    set command $argv[1]
      set -e argv[1]

      switch "$command"
      case rehash shell
          eval (ndenv sh-"$command" $argv | psub)
      case '*'
          command ndenv "$command" $argv
      end
  end
end


# vim -------------------------------------------------------------------------

if type -p nvim > /dev/null 2>&1
  set -Ux EDITOR nvim
else if type -p vim > /dev/null 2>&1
  set -Ux EDITOR vim
else
  set -Ux EDITOR vi
end


# git -------------------------------------------------------------------------

set -Ux GIT_MERGE_AUTOEDIT no


# -----------------------------------------------------------------------------

set -U fish_user_paths (echo $fish_user_paths | tr ' ' '\n' | awk '!a[$0]++' -)
set -gx PATH (echo $PATH | tr ' ' '\n' | awk '!a[$0]++' -)

# vim: se sw=2 ts=2 sts=2 et ft=fish :
