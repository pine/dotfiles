# ~/.config/fish/completions/jenv.fish

# fish completion for jenv, copied from /usr/share/fish/completions/rbenv.fish

function __fish_jenv_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 -a $cmd[1] = 'jenv' ]
    return 0
  end

  return 1
end

function __fish_jenv_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

function __fish_jenv_executables
  jenv exec --complete
end

function __fish_jenv_installed_pythons
  jenv versions --bare
end

function __fish_jenv_official_pythons
  python-build --definitions
end

function __fish_jenv_prefixes
  jenv prefix --complete
end

### commands
complete -f -c jenv -n '__fish_jenv_needs_command' -a commands -d 'List all jenv commands'
complete -f -c jenv -n '__fish_jenv_using_command commands' -a '--complete --sh --no-sh'

### completions
complete -f -c jenv -n '__fish_jenv_needs_command' -a completions

### exec
complete -f -c jenv -n '__fish_jenv_needs_command' -a exec
complete -f -c jenv -n '__fish_jenv_using_command exec' -a '(__fish_jenv_executables)'

### global
complete -f -c jenv -n '__fish_jenv_needs_command' -a global -d 'Set or show the global Java version'
complete -f -c jenv -n '__fish_jenv_using_command global' -a '(__fish_jenv_installed_pythons)'

### help
complete -f -c jenv -n '__fish_jenv_needs_command' -a help

### hooks
complete -f -c jenv -n '__fish_jenv_needs_command' -a hooks

### init
complete -f -c jenv -n '__fish_jenv_needs_command' -a init

### install
complete -f -c jenv -n '__fish_jenv_needs_command' -a install -d 'Install a python version'
complete -f -c jenv -n '__fish_jenv_using_command install' -a '(__fish_jenv_official_pythons)'

### local
complete -f -c jenv -n '__fish_jenv_needs_command' -a local -d 'Set or show the local directory-specific Java version'
complete -f -c jenv -n '__fish_jenv_using_command local' -a '(__fish_jenv_installed_pythons)'

### prefix
complete -f -c jenv -n '__fish_jenv_needs_command' -a prefix -d 'Shows a python version installed folder'
complete -f -c jenv -n '__fish_jenv_using_command prefix' -a '(__fish_jenv_prefixes)'

### rehash
complete -f -c jenv -n '__fish_jenv_needs_command' -a rehash -d 'Rehash jenv shims (run this after installing binaries)'

### root
complete -f -c jenv -n '__fish_jenv_needs_command' -a root -d 'jenv root folder'

### shell
complete -f -c jenv -n '__fish_jenv_needs_command' -a shell -d 'Set or show the shell-specific Java version'
complete -f -c jenv -n '__fish_jenv_using_command shell' -a '--unset (__fish_jenv_installed_pythons)'

### shims
complete -f -c jenv -n '__fish_jenv_needs_command' -a shims
complete -f -c jenv -n '__fish_jenv_using_command shims' -a '--short'

### version
complete -f -c jenv -n '__fish_jenv_needs_command' -a version  -d 'Show the current Java version'

### version-file
complete -f -c jenv -n '__fish_jenv_needs_command' -a version-file

### version-file-read
complete -f -c jenv -n '__fish_jenv_needs_command' -a version-file-read

### version-file-write
complete -f -c jenv -n '__fish_jenv_needs_command' -a version-file-write

### version-name
complete -f -c jenv -n '__fish_jenv_needs_command' -a version-name

### version-origin
complete -f -c jenv -n '__fish_jenv_needs_command' -a version-origin

### versions
complete -f -c jenv -n '__fish_jenv_needs_command' -a versions -d 'List all Java versions known by jenv'

### whence
complete -f -c jenv -n '__fish_jenv_needs_command' -a whence -d 'List all Java versions with the given command'
complete -f -c jenv -n '__fish_jenv_using_command whence' -a '--complete --path'

### which
complete -f -c jenv -n '__fish_jenv_needs_command' -a which -d 'Show the full path for the given Java command'
complete -f -c jenv -n '__fish_jenv_using_command which' -a '(__fish_jenv_executables)'
