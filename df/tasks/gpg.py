"""GPG task: import GPG keys declared in each project's ``config/gpg.yml``.

Ported from secured/tasks/gpg.bash. Unlike the home task, importing a key has
no destination path/mode to manage -- the fetched bytes are piped straight
into ``gpg --import``, which is idempotent.

Config schema (validated by the models below)::

    keys:
      - file: { path: example_gmail_com.pub }
      - infisical:
          project_id: ...
          env: main
          name: gpg_prv_key_example_gmail_com

Each ``keys:`` entry is a Map with exactly one of ``file``/``op``/``infisical``
set, naming the source of the key material.
"""

from __future__ import annotations

import subprocess

from pydantic import BaseModel, ConfigDict, model_validator

from df.context import Context, Project
from df.secrets import infisical_get, op_read
from df.tasks.base import Task


class GpgFileSource(BaseModel):
    model_config = ConfigDict(extra="forbid")

    path: str  # relative to <project>/resources/gpg/


class GpgOpSource(BaseModel):
    model_config = ConfigDict(extra="forbid")

    ref: str  # passed to `op read <ref>`


class GpgInfisicalSource(BaseModel):
    model_config = ConfigDict(extra="forbid")

    project_id: str
    env: str
    name: str


class GpgKey(BaseModel):
    model_config = ConfigDict(extra="forbid")

    file: GpgFileSource | None = None
    op: GpgOpSource | None = None
    infisical: GpgInfisicalSource | None = None

    @model_validator(mode="after")
    def _exactly_one_spec(self) -> "GpgKey":
        specs = [s for s in (self.file, self.op, self.infisical) if s is not None]
        if len(specs) != 1:
            raise ValueError("exactly one of file/op/infisical must be set")
        return self

    @property
    def spec(self) -> GpgFileSource | GpgOpSource | GpgInfisicalSource:
        assert self.file or self.op or self.infisical
        return self.file or self.op or self.infisical  # type: ignore[return-value]


class GpgConfig(BaseModel):
    model_config = ConfigDict(extra="forbid")

    keys: list[GpgKey] = []


class GpgTask(Task):
    name = "gpg"

    def run_project(self, ctx: Context, project: Project) -> None:
        config = project.config("gpg.yml", GpgConfig)
        if config is None:
            return
        for key in config.keys:
            self._import_key(project, key)

    def _import_key(self, project: Project, key: GpgKey) -> None:
        spec = key.spec

        if isinstance(spec, GpgOpSource):
            print("Importing GPG key from 1Password ...")
            content = op_read(spec.ref)
        elif isinstance(spec, GpgInfisicalSource):
            print(f"Importing GPG key from Infisical secret \"{spec.name}\" ...")
            content = infisical_get(spec.name, spec.project_id, spec.env)
        elif isinstance(spec, GpgFileSource):
            src = project.resources_dir / "gpg" / spec.path
            print(f"Importing GPG key from {src} ...")
            content = src.read_bytes()
        else:
            raise ValueError(f"unexpected gpg key spec type: {type(spec)!r}")

        subprocess.run(["gpg", "--import"], input=content, check=True)
