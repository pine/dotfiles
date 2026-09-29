# dotfiles v3

Personal dotfiles, not intended for use by others.

An installer that sets up a development environment: it symlinks config files
into `$HOME`, installs Homebrew and Mac App Store packages, imports GPG keys,
and runs setup scripts. It is written in Python and run via
[uv](https://docs.astral.sh/uv/), which `bin/install.sh` downloads into
`vendor/` on first run, so uv does not have to be installed beforehand.

## Requirements

macOS on Apple Silicon. `bin/install.sh` exits with an error anywhere else.

## Getting started
First, you must clone the repository in your development computer.

```sh
$ curl -L https://raw.githubusercontent.com/pine/dotfiles/master/bin/setup.sh | bash
```

If the repository has been already cloned, please execute following commands.

```sh
$ ./bin/install.sh
```

The installer is idempotent, so it is safe to run again at any time.

## Running only some tasks

Pass task names to narrow down what runs. Arguments select tasks but never
reorder them — they always run in the order below, because that order encodes
dependencies between them.

```sh
$ ./bin/install.sh brew home fish
```

Available tasks: `brew`, `mas`, `home`, `fish`, `git`, `script`, `gpg`.

## License
MIT &copy; Pine Mizune
