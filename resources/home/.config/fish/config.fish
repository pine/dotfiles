# ~/.config/fish/config.fish

# env -------------------------------------------------------------------------

set -g CDPATH .
test -d ~/project/pine; and set -g CDPATH $CDPATH ~/project/pine
test -d ~/project; and set -g CDPATH $CDPATH ~/project

begin
  set -l paths /sbin /usr/sbin /bin /usr/sbin \
    /usr/local/sbin /usr/local/bin \
    /usr/local/*/bin  \
    ~/Library/Android/sdk/tools/bin ~/Library/Android/sdk/platform-tools \
    /usr/local/Homebrew/bin \
    /usr/lib/dart/bin \
    /usr/local/opt/mysql@5.7/bin \
    ~/.cargo/bin \
    ~/bin ~/bin/*/bin

  for p in $paths
    test -d $p; and set -x PATH $p $PATH
  end
end

set -x LANG en_US.UTF-8
set -x LC_TIME C
set -x LC_LC_NUMERIC C

if test -d ~/Library/Android/sdk/
  set -x ANDROID_HOME ~/Library/Android/sdk/
end

# history ---------------------------------------------------------------------

function history-merge --on-event fish_preexec
	history --save
	history --merge
end


# anyenv ----------------------------------------------------------------------

if test -d ~/.anyenv
  set -x PATH $HOME/.anyenv/bin $PATH
end

# goenv
if test -d ~/.anyenv/envs/goenv
  set -x GOENV_ROOT "$HOME/.anyenv/envs/goenv"
  set -x PATH "$GOENV_ROOT/bin" $PATH
  status --is-interactive; and . (goenv init - | psub)
end

# rbenv
if test -d ~/.anyenv/envs/rbenv
  set -x RBENV_ROOT "$HOME/.anyenv/envs/rbenv"
  set -x PATH "$RBENV_ROOT/bin" $PATH
  status --is-interactive; and . (rbenv init - | psub)
end

# plenv
if test -d ~/.anyenv/envs/plenv
  set -x PLENV_ROOT "$HOME/.anyenv/envs/plenv"
  set -x PATH "$PLENV_ROOT/bin" $PATH
  status --is-interactive; and . (plenv init - | psub)
end

# swiftenv
if test -d ~/.anyenv/envs/swiftenv
  set -x SWIFTENV_ROOT "$HOME/.anyenv/envs/swiftenv"
  set -x PATH "$SWIFTENV_ROOT/bin" $PATH
  status --is-interactive; and . (swiftenv init - | psub)
end

# scalaenv
if test -d ~/.anyenv/envs/scalaenv
  set -x SCALAENV_ROOT "$HOME/.anyenv/envs/scalaenv"
  set -x PATH "$SCALAENV_ROOT/bin" $PATH
  status --is-interactive; and . (scalaenv init - | psub)
end

# rustup
if test -f ~/.cargo/env
  source ~/.cargo/env
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

for i in ~/.config/fish/postconf.d/* ;
  source $i
end

set -U fish_user_paths (echo $fish_user_paths | tr ' ' '\n' | awk '!a[$0]++' -)
set -gx PATH (echo $PATH | tr ' ' '\n' | awk '!a[$0]++' -)

# vim: se sw=2 ts=2 sts=2 et ft=fish :
