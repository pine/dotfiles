# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository (not intended for use by others). It is a shell-based installer that sets up a macOS or Ubuntu development environment — symlinking config files into `$HOME`, installing Homebrew/apt packages, Mac App Store apps, and version managers, and running setup scripts. Scripts target the macOS system Bash (version 3.x).

## Running the installer

```sh
# Full install (the usual entry point)
./bin/install.sh

# Run only specific tasks
./bin/install.sh brew home fish
```

The installer is idempotent — it can be run multiple times safely.

## Architecture

### Execution flow

The orchestration is Python; the individual tasks are still bash. This is
phase 1 of an ongoing bash → uv/Python migration (control flow first, tasks
ported one at a time later).

1. `bin/install.sh` is a thin wrapper: it ensures `uv` is installed, then runs
   the `df` package (`uv run python -m df "$@"`).
2. `df/cli.py` (the orchestrator) computes the `DF_*`/`DOTFILES_*` environment
   variables the tasks expect, builds the ordered task list (CLI args, else
   `config/tasks.conf` + the secured `tasks.conf`), and dispatches each
   `(task, action)` to the bash runner shim.
3. `bin/run_task.bash` is invoked once per `(task, action)`. It re-sources — on
   every call, by design, nothing is cached — the init scripts, the shared
   functions, and every task file, then calls `tasks_<task>_<action>` if defined.
   - **init scripts** (`init/*.bash`), filename-sorted: set `ENV_OS`
     (darwin/linux), `ENV_ARCH` (amd64/arm64), `ENV_USE` (personal/corporate),
     install `yq`, and extract the secured archive.
   - **functions** (`functions/*.bash`): config file parser plus
     `env_name`/`env_is_macos`/`is-macos`/`has-apt` helpers.
   - **tasks** (`tasks/*.bash` + secured `tasks/*.bash`): all sourced so any
     `tasks_*` function is resolvable.

### Task system

Tasks are defined in `config/tasks.conf`. For each task name (e.g. `brew`), the installer calls these functions if they exist:
- `tasks_<name>_preinstall`
- `tasks_<name>_install`
- `tasks_<name>_postinstall`

Task order: `apt → brew → mas → home → fish → anyenv → git → script → pref`

### Config files

`config/` contains declarative config in `.conf` (line-based) and `.yml` (YAML) formats. Key files:
- `config/tasks.conf` — ordered list of tasks to run
- `config/brew/pkgs.conf`, `config/brew/cask-pkgs.conf` — Homebrew formula/cask packages
- `config/home/files.yml` — dotfiles to deploy into `$HOME`
- `config/home/directories.yml` — directories to create in `$HOME` before files are deployed
- `config/anyenv.yml` — version managers and their plugins
- `config/script/files.yml` — shell scripts from `resources/script/` to execute

### Home file deployment (`tasks/home.bash`)

Files listed in `config/home/files.yml` are deployed from `resources/home/` to `$HOME/`. Each entry supports:
- Default: creates a symlink `$HOME/<path> → resources/home/<path>`
- `strategy: copy` — copies the file instead and sets `chmod 600`
- `copy_from_op: <op-reference>` — fetches content from 1Password via `op read` and writes it directly (takes precedence over `strategy`)

The home task merges files from three sources: this repo, the `secured` submodule, and the corporate dotfiles repo (path defined as `CORPORATE_DIR` in `df/cli.py`).

### Secured submodule

`secured/` is a private git submodule. See that directory for details.

When making changes related to `secured`, document them within the `secured` submodule itself. Do not let details about `secured` changes leak into commit messages or documentation in this repository.

### Environment detection

- `ENV_USE` is set to `corporate` or `personal` based on the current username.
- Some Homebrew packages have an `env=` option to install only in the matching environment.
- Scripts in `resources/script/` receive `ENV_NAME` as an environment variable.
