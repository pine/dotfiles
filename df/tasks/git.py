"""Git task: clone repositories declared in each project's ``config/git.yml``.

Ported from tasks/git.bash. The orchestrator drives the per-project loop, so
this task only implements ``run_project`` -- it processes one project's
``git.yml`` per call.

Config schema (validated by the models below)::

    repos:
      - url: git@github.com:owner/repo.git
        path: ~/some/dir
        ignore_errors: false   # optional, default false
"""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

from pydantic import BaseModel, ConfigDict

from df.context import Context, Project
from df.tasks.base import Task


class Repo(BaseModel):
    model_config = ConfigDict(extra="forbid")  # reject unknown keys (typos)

    url: str
    path: str
    ignore_errors: bool = False


class GitConfig(BaseModel):
    model_config = ConfigDict(extra="forbid")

    repos: list[Repo] = []


class GitTask(Task):
    name = "git"

    def run_project(self, ctx: Context, project: Project) -> None:
        config = project.config("git.yml", GitConfig)
        if config is None:
            return
        for repo in config.repos:
            self._clone_repo(repo)

    def _clone_repo(self, repo: Repo) -> None:
        dest = Path(repo.path).expanduser()

        print(f"Checking if {repo.path} already exists ... ", end="")
        if dest.is_dir():
            print("yes")
            return
        print("no")

        result = subprocess.run(["git", "clone", repo.url, str(dest)])
        if result.returncode != 0:
            print(f"ERROR: Failed to clone {repo.url} into {repo.path}", file=sys.stderr)
            if not repo.ignore_errors:
                raise SystemExit(result.returncode)
