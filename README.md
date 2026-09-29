# dotfiles

> Personal dotfiles

Sets up a macOS (Apple Silicon) development environment: symlinks config files
into `$HOME`, installs Homebrew and Mac App Store packages, imports GPG keys,
and runs setup scripts. Written in Python, run via
[uv](https://docs.astral.sh/uv/).

## Getting started
First, you must clone the repository in your development computer.

```sh
$ curl -L https://raw.githubusercontent.com/pine/dotfiles/main/bin/setup.sh | bash
```

If the repository has been already cloned, please execute following commands.

```sh
$ ./bin/install.sh
```

Running it again is safe.

## Running only some tasks

Task names narrow down what runs, without reordering it:

```sh
$ ./bin/install.sh brew home fish
```

Available tasks: `brew`, `mas`, `home`, `fish`, `git`, `script`, `gpg`.

## Development

```sh
$ uv run ruff check
```

ruff is pinned in the `dev` dependency group; its settings live under
`[tool.ruff]` in `pyproject.toml`.

## License
MIT &copy; Pine Mizune
