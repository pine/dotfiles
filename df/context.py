"""Shared context for the Python task layer.

A ``Project`` is one source of dotfiles configuration/resources; a ``Context``
bundles the projects with the paths and environment the tasks need. Tasks loop
over ``ctx.projects`` and process each project's config independently (rather
than merging configs from every source into one).
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path
from typing import TypeVar

from pydantic import BaseModel

from df.yaml_config import load_yaml

M = TypeVar("M", bound=BaseModel)


def _env_name() -> str:
    """Resolve the work/personal environment name, mirroring env_name() in functions/env.bash."""
    return "work" if os.environ.get("USER") == "kazuki-matsushita" else "personal"


@dataclass(frozen=True)
class Project:
    """A single source of dotfiles config/resources.

    ``main`` is this repo, ``secure`` is the secured submodule, ``work`` is the
    corporate dotfiles repo. A project's root always exists on disk, but a given
    config file inside it may not (tasks skip missing files).
    """

    name: str
    root: Path

    @property
    def config_dir(self) -> Path:
        return self.root / "config"

    @property
    def resources_dir(self) -> Path:
        return self.root / "resources"

    def config(self, name: str, model: type[M]) -> M | None:
        """Load and validate a YAML config file from this project.

        ``model`` is the Pydantic model describing the file's schema (e.g.
        ``GitConfig`` for ``"git.yml"``). Returns ``None`` when there is no
        config -- whether the file is missing or empty, both are treated the
        same. A present-but-invalid file raises ``pydantic.ValidationError``.
        """
        data = load_yaml(self.config_dir / name)
        if data is None:
            return None
        return model.model_validate(data)


@dataclass(frozen=True)
class Context:
    """Everything a Python task needs to run.

    ``os_environ`` is the raw OS environment (plus the DF_*/DOTFILES_*
    variables set up for the bash tasks); ``env`` is the resolved
    work/personal environment name (see _env_name() above, mirrors ENV_NAME in
    the bash tasks).
    """

    root: Path
    tmp_dir: Path
    home: Path
    projects: list[Project]
    os_environ: dict[str, str]
    env: str


def build_context(
    root: Path,
    secured_root: Path,
    corporate_root: Path,
    tmp_dir: Path,
    os_environ: dict[str, str],
) -> Context:
    """Construct the Context, deriving the ordered project list.

    Project order (main -> secure -> work) matches the source ordering used by
    the bash tasks (e.g. tasks/home.bash).
    """
    projects = [
        Project(name="main", root=root),
        Project(name="secure", root=secured_root),
        Project(name="work", root=corporate_root),
    ]
    return Context(
        root=root,
        tmp_dir=tmp_dir,
        home=Path.home(),
        projects=projects,
        os_environ=os_environ,
        env=_env_name(),
    )
