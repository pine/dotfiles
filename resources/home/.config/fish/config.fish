# ~/.config/fish/config.fish

# env -------------------------------------------------------------------------

set -g CDPATH .
test -d ~/project/pine; and set -g CDPATH $CDPATH ~/project/pine
test -d ~/project; and set -g CDPATH $CDPATH ~/project

begin
  set -l paths /sbin /usr/sbin /bin /usr/sbin \
    /usr/local/sbin /usr/local/bin \
    /opt/homebrew/bin \
    /usr/local/*/bin  \
    ~/Library/Android/sdk/tools/bin ~/Library/Android/sdk/platform-tools \
    /usr/local/opt/terraform@0.13/bin \
    /usr/local/Homebrew/bin \
    /usr/lib/dart/bin \
    /usr/local/opt/mysql@5.7/bin \
    ~/project/flutter/flutter/bin \
    ~/.cargo/bin \
    ~/bin \
    ~/bin/*/bin \
    ~/.rd/bin \
    ~/opt/zms-cli \
    ~/opt/athenz-utils

  for p in $paths
    test -d $p; and set -x PATH $p $PATH
  end
end

set -x LANG en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8
set -x LC_TIME C
set -x LC_NUMERIC C

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

# rbenv
if test -d ~/.anyenv/envs/rbenv
  set -x RBENV_ROOT "$HOME/.anyenv/envs/rbenv"
  set -x PATH "$RBENV_ROOT/bin" $PATH
  status --is-interactive; and rbenv init - | source
end

# plenv
if test -d ~/.anyenv/envs/plenv
  set -x PLENV_ROOT "$HOME/.anyenv/envs/plenv"
  set -x PATH "$PLENV_ROOT/bin" $PATH
  status --is-interactive; and plenv init - | source
end

# swiftenv
if test -d ~/.anyenv/envs/swiftenv
  set -x SWIFTENV_ROOT "$HOME/.anyenv/envs/swiftenv"
  set -x PATH "$SWIFTENV_ROOT/bin" $PATH
  status --is-interactive; and swiftenv init - | source
end

# scalaenv
if test -d ~/.anyenv/envs/scalaenv
  set -x SCALAENV_ROOT "$HOME/.anyenv/envs/scalaenv"
  set -x PATH "$SCALAENV_ROOT/bin" $PATH
  status --is-interactive; and scalaenv init - | source
end

# rustup
if test -f ~/.cargo/env
  # source ~/.cargo/env
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


# poetry ----------------------------------------------------------------------

set -Ux POETRY_VIRTUALENVS_IN_PROJECT true


# -----------------------------------------------------------------------------

for i in ~/.config/fish/postconf.d/* ;
  source $i
end

set -U fish_user_paths (echo $fish_user_paths | tr ' ' '\n' | awk '!a[$0]++' -)
set -gx PATH (echo $PATH | tr ' ' '\n' | awk '!a[$0]++' -)

# vim: se sw=2 ts=2 sts=2 et ft=fish :
