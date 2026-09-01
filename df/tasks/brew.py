"""Brew task: install Homebrew itself plus formulae/casks declared in each
project's ``config/brew.yml``.

Ported from tasks/brew.bash + tasks/pre-brew.bash + tasks/post-brew.bash.
Unlike the other ported tasks this one does not use ``before_project``/
``run_project`` -- everything except the actual formula/cask install and
uninstall calls happens in ``before`` (config loading, bootstrapping Homebrew
itself, taps, ``brew update``/``brew upgrade``), and ``run`` performs the
package install/uninstall in two passes across every project: first every
``state: absent`` package (uninstall), then every ``state: present`` package
(install). Uninstalling everything before installing anything avoids name
conflicts between formulae (e.g. ``mysql`` vs ``mysql@8.0``).

Config schema (validated by the models below)::

    options:
      update: true
      upgrade: true

    taps:
      - some/tap

    formulae:
      - { name: apache-geode, state: absent }
      - { name: deno, state: { work: present } }

    casks:
      - { name: 1password, state: { work: present } }
      - { name: discord, state: { personal: present, work: absent } }

Each ``formulae:``/``casks:`` entry's ``state`` is either a plain
``present``/``absent`` (applies regardless of env) or a map keyed by env
(``work``/``personal``) for packages that should only be managed in specific
envs -- an env missing from the map means this task never touches that
package for that env.
"""

from __future__ import annotations

import os
import subprocess
from pathlib import Path
from typing import Literal

from pydantic import BaseModel, ConfigDict

from df.context import Context, Project
from df.tasks.base import Task

HOMEBREW_INSTALL_URL = "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
HOMEBREW_BIN_DIR = Path("/opt/homebrew/bin")
HOMEBREW_BIN = HOMEBREW_BIN_DIR / "brew"

EnvName = Literal["work", "personal"]
State = Literal["present", "absent"]


class BrewOptions(BaseModel):
    model_config = ConfigDict(extra="forbid")

    update: bool = False
    upgrade: bool = False


class BrewPkg(BaseModel):
    model_config = ConfigDict(extra="forbid")

    name: str
    state: State | dict[EnvName, State] = "present"

    def resolved_state(self, env: str) -> State | None:
        """State to apply for the given env, or None if this package isn't
        managed for that env at all (no key present in the state map)."""
        if isinstance(self.state, dict):
            return self.state.get(env)
        return self.state


class BrewConfig(BaseModel):
    model_config = ConfigDict(extra="forbid")

    options: BrewOptions | None = None
    taps: list[str] = []
    formulae: list[BrewPkg] = []
    casks: list[BrewPkg] = []


class BrewTask(Task):
    name = "brew"

    def before(self, ctx: Context) -> None:
        self._configs: dict[str, BrewConfig | None] = {
            project.name: project.config("brew.yml", BrewConfig) for project in ctx.projects
        }
        configs = [c for c in self._configs.values() if c is not None]

        self._bootstrap_brew(ctx)

        if any(c.options and c.options.update for c in configs):
            self._brew_update()

        self._installed_taps = self._list_taps()
        for config in configs:
            for tap in config.taps:
                self._ensure_tap(tap)

        subprocess.run(["brew", "tap", "--repair"], check=True)

        if any(c.options and c.options.update for c in configs):
            self._brew_update()
        if any(c.options and c.options.upgrade for c in configs):
            self._brew_upgrade()

    def run(self, ctx: Context) -> None:
        self._installed_formulae = self._list_installed("formula")
        self._installed_casks = self._list_installed("cask")

        configs = [c for c in self._configs.values() if c is not None]

        # Uninstall phase: resolve every package's state before installing
        # anything, since some formulae/casks conflict by name (e.g. mysql
        # vs mysql@8.0) and need the old one gone first.
        for config in configs:
            for pkg in config.formulae:
                self._process_uninstall(ctx, pkg, "formula")
            for pkg in config.casks:
                self._process_uninstall(ctx, pkg, "cask")

        for config in configs:
            for pkg in config.formulae:
                self._process_install(ctx, pkg, "formula")
            for pkg in config.casks:
                self._process_install(ctx, pkg, "cask")

    def after(self, ctx: Context) -> None:
        subprocess.run(["brew", "cleanup", "-s"], check=True)

    def _bootstrap_brew(self, ctx: Context) -> None:
        if HOMEBREW_BIN.exists():
            if str(HOMEBREW_BIN_DIR) not in os.environ.get("PATH", "").split(os.pathsep):
                os.environ["PATH"] = os.pathsep.join([str(HOMEBREW_BIN_DIR), os.environ.get("PATH", "")])
            return

        tmp_dir = ctx.tmp_dir / "brew"
        tmp_dir.mkdir(parents=True, exist_ok=True)
        script_path = tmp_dir / "install.sh"

        subprocess.run(["curl", "-sL", HOMEBREW_INSTALL_URL, "-o", str(script_path)], check=True)
        script_path.chmod(0o755)
        subprocess.run([str(script_path)], check=True)

        if str(HOMEBREW_BIN_DIR) not in os.environ.get("PATH", "").split(os.pathsep):
            os.environ["PATH"] = os.pathsep.join([str(HOMEBREW_BIN_DIR), os.environ.get("PATH", "")])

    def _brew_update(self) -> None:
        print("Updating Homebrew ...")
        if subprocess.run(["brew", "update"]).returncode != 0:
            subprocess.run(["brew", "update"], check=True)

    def _brew_upgrade(self) -> None:
        print("Upgrading Homebrew ...")
        if subprocess.run(["brew", "upgrade", "--no-ask"]).returncode != 0:
            subprocess.run(["brew", "upgrade", "--no-ask"], check=True)

    def _list_taps(self) -> set[str]:
        result = subprocess.run(["brew", "tap"], check=True, capture_output=True, text=True)
        return set(result.stdout.split())

    def _ensure_tap(self, tap: str) -> None:
        print(f"Checking if {tap} is tapped ... ", end="")
        if tap in self._installed_taps:
            print("yes")
            return
        print("no")
        print(f"Tapping {tap}")
        subprocess.run(["brew", "tap", tap], check=True)
        self._installed_taps.add(tap)

    def _list_installed(self, repository: Literal["formula", "cask"]) -> set[str]:
        result = subprocess.run(
            ["brew", "list", f"--{repository}"], check=True, capture_output=True, text=True
        )
        return set(result.stdout.split())

    def _is_installed(self, name: str, repository: Literal["formula", "cask"]) -> bool:
        cache = self._installed_formulae if repository == "formula" else self._installed_casks
        if name in cache:
            return True
        result = subprocess.run(["brew", "list", name, f"--{repository}"], capture_output=True)
        return result.returncode == 0

    def _process_install(self, ctx: Context, pkg: BrewPkg, repository: Literal["formula", "cask"]) -> None:
        if pkg.resolved_state(ctx.env) != "present":
            return

        cache = self._installed_formulae if repository == "formula" else self._installed_casks
        print(f"Checking if {pkg.name} is installed ... ", end="")
        if self._is_installed(pkg.name, repository):
            print("yes")
            return
        print("no")
        print(f"Installing {pkg.name} ...")
        subprocess.run(["brew", "install", pkg.name, f"--{repository}"], check=True)
        cache.add(pkg.name)

    def _process_uninstall(self, ctx: Context, pkg: BrewPkg, repository: Literal["formula", "cask"]) -> None:
        if pkg.resolved_state(ctx.env) != "absent":
            return

        cache = self._installed_formulae if repository == "formula" else self._installed_casks
        print(f"Checking if {pkg.name} is uninstalled ... ", end="")
        if not self._is_installed(pkg.name, repository):
            print("yes")
            return
        print("no")
        print(f"Uninstalling {pkg.name} ...")
        subprocess.run(["brew", "uninstall", pkg.name, f"--{repository}"], check=True)
        cache.discard(pkg.name)
