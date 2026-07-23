# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository (not intended for use by others). It is an installer that sets up a macOS (Apple Silicon) development environment — symlinking config files into `$HOME`, installing Homebrew and Mac App Store packages and version managers, and running setup scripts. Orchestration is Python (via uv); the individual tasks are bash and target the macOS system Bash (version 3.x).

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
   `(task, action)` to the bash runner shim. After all bash tasks finish it
   runs the Python task layer (see below).
3. `bin/run_task.bash` is invoked once per `(task, action)`. It re-sources — on
   every call, by design, nothing is cached — the init scripts, the shared
   functions, and every task file, then calls `tasks_<task>_<action>` if defined.
   - **init scripts** (`init/*.bash`), filename-sorted: set `ENV_OS`
     (darwin/linux), `ENV_ARCH` (amd64/arm64), `ENV_USE` (personal/corporate),
     install `yq`, and extract the secured archive.
   - **functions** (`functions/*.bash`): config file parser plus
     `env_name`/`env_is_macos`/`is-macos` helpers.
   - **tasks** (`tasks/*.bash` + secured `tasks/*.bash`): all sourced so any
     `tasks_*` function is resolvable.

### Task system

Tasks are defined in `config/tasks.conf`. For each task name (e.g. `brew`), the installer calls these functions if they exist:
- `tasks_<name>_preinstall`
- `tasks_<name>_install`
- `tasks_<name>_postinstall`

Task order: `brew → mas → home → fish → anyenv → git → script → pref`

### Python task layer (`df/tasks/`)

Tasks are being ported from bash to Python one at a time. Ported tasks live in
`df/tasks/` and run **after** every bash task has completed (the ordering
within `config/tasks.conf` no longer applies to them; their order is the
`PYTHON_TASKS` list in `df/tasks/__init__.py`). A Python task still runs only
when its `name` is selected — i.e. present in the effective task list (CLI args
or `tasks.conf`), so the task name stays in `config/tasks.conf`.

- `df/tasks/base.py` — `Task` base class with three phases (`before` → `run` →
  `after`), each in a whole-task form (`before`/`run`/`after`, called once) and
  a per-project form (`before_project`/`run_project`/`after_project`, called per
  project with a `Project`). Within a phase the whole-task hook fires first,
  then the per-project hook for each project. All hooks default to no-ops, so a
  task overrides only what it needs (the git task implements just `run_project`).
- `df/tasks/__init__.py` — `PYTHON_TASKS: list[Task]`, the ordered registry.
  Add a task by appending its instance here.
- `df/context.py` — `Context` (paths/env) and `Project`. A **`Project`** is one
  source of config/resources: `main` (this repo), `secure` (secured submodule),
  `work` (corporate repo). Tasks loop over `ctx.projects` and process each
  project's config independently (they do not merge configs across sources).
  `Project.config(name, model)` loads a YAML file and validates it against a
  Pydantic model, returning the typed model instance (or `None` when the file
  is missing or empty, both treated as "no config").
- `df/yaml_config.py` — `load_yaml(path)` (PyYAML); returns `None` for a missing
  or empty file. Wrapped by `Project.config`.

Config schemas are Pydantic models (`extra="forbid"`, so unknown keys are
rejected as typos) defined alongside the task that reads them.

Ported so far: `git` (`df/tasks/git.py`, reads each project's `config/git.yml`
into the `GitConfig`/`Repo` models).

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
