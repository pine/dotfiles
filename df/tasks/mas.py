"""Mas task: install Mac App Store packages declared in each project's
``config/mas.yml``.

Ported from tasks/mas.bash. ``mas list`` is run once (in ``before``, shared
across every project) so each project's ``run_project`` call doesn't re-fetch
it.

Config schema (validated by the models below)::

    packages:
      - id: 302584613  # Amazon Kindle
"""

from __future__ import annotations

import subprocess

from pydantic import BaseModel, ConfigDict

from df.context import Context, Project
from df.tasks.base import Task


class MasPkg(BaseModel):
    model_config = ConfigDict(extra="forbid")

    id: int


class MasConfig(BaseModel):
    model_config = ConfigDict(extra="forbid")

    packages: list[MasPkg] = []


class MasTask(Task):
    name = "mas"

    def before(self, ctx: Context) -> None:
        self._installed_ids = self._list_installed()

    def run_project(self, ctx: Context, project: Project) -> None:
        config = project.config("mas.yml", MasConfig)
        if config is None:
            return
        for pkg in config.packages:
            print(f"Checking if mas package {pkg.id} is already installed ... ", end="")
            if pkg.id in self._installed_ids:
                print("yes")
            else:
                print("no")
                self._install(pkg.id)

    def _list_installed(self) -> set[int]:
        result = subprocess.run(
            ["mas", "list"], check=True, capture_output=True, text=True
        )
        installed: set[int] = set()
        for line in result.stdout.splitlines():
            first = line.split(maxsplit=1)[0] if line.split() else ""
            if first:
                installed.add(int(first))
        return installed

    def _install(self, pkg_id: int) -> None:
        print(f"> mas info {pkg_id}")
        subprocess.run(["mas", "info", str(pkg_id)], check=True)
        print(f"> mas install {pkg_id}")
        subprocess.run(["mas", "install", str(pkg_id)], check=True)
