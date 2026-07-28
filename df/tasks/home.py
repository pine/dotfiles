"""Home task: deploy dotfiles into $HOME as declared in each project's ``config/home.yml``.

Ported from tasks/home.bash + tasks/pre-home.bash. ``directories:`` entries are
created in ``before_project`` (mirrors the old preinstall action); ``files:``
entries are deployed in ``run_project`` (mirrors the old install action) --
this ordering matters because the orchestrator runs ``before_project`` for
every project before ``run_project`` for any of them, matching the old
per-action (not per-project) sequencing.

Config schema (validated by the models below)::

    files:
      - file: { path: .gitconfig }
      - file: { path: .ssh/config, strategy: copy, mode: '600' }
      - op:
          path: .ssh/work/id_ed25519
          ref: op://vault/item/field
          mode: '600'
      - infisical:
          path: .ssh/id_ecdsa.commons
          project_id: ...
          env: main
          name: id_ecdsa_commons
          mode: '600'

    directories:
      - path: .go
      - path: .ssh
        mode: '700'

Each ``files:`` entry is a Map with exactly one of ``file``/``op``/``infisical``
set -- the key names the source of the content, and each key's value (a
``FileSpec``/``OpSpec``/``InfisicalSpec``) carries the destination ``path``
plus whatever else that source needs. ``mode`` is optional on all three; when
omitted, no chmod is performed.
"""

from __future__ import annotations

import shutil
import stat
import subprocess
from typing import Literal

from pydantic import BaseModel, ConfigDict, model_validator

from df.context import Context, Project
from df.tasks.base import Task


class FileSpec(BaseModel):
    model_config = ConfigDict(extra="forbid")

    path: str
    strategy: Literal["symlink", "copy"] = "symlink"
    mode: str | None = None  # only meaningful when strategy == "copy"

    @model_validator(mode="after")
    def _no_mode_on_symlink(self) -> "FileSpec":
        if self.strategy == "symlink" and self.mode is not None:
            raise ValueError("mode is not meaningful with strategy: symlink")
        return self


class OpSpec(BaseModel):
    model_config = ConfigDict(extra="forbid")

    path: str
    ref: str  # passed to `op read <ref>`
    mode: str | None = None


class InfisicalSpec(BaseModel):
    model_config = ConfigDict(extra="forbid")

    path: str
    project_id: str
    env: str
    name: str
    mode: str | None = None


class HomeFile(BaseModel):
    model_config = ConfigDict(extra="forbid")

    file: FileSpec | None = None
    op: OpSpec | None = None
    infisical: InfisicalSpec | None = None

    @model_validator(mode="after")
    def _exactly_one_spec(self) -> "HomeFile":
        specs = [s for s in (self.file, self.op, self.infisical) if s is not None]
        if len(specs) != 1:
            raise ValueError("exactly one of file/op/infisical must be set")
        return self

    @property
    def spec(self) -> FileSpec | OpSpec | InfisicalSpec:
        assert self.file or self.op or self.infisical
        return self.file or self.op or self.infisical  # type: ignore[return-value]


class HomeDirectory(BaseModel):
    model_config = ConfigDict(extra="forbid")

    path: str
    mode: str | None = None


class HomeConfig(BaseModel):
    model_config = ConfigDict(extra="forbid")

    files: list[HomeFile] = []
    directories: list[HomeDirectory] = []


class HomeTask(Task):
    name = "home"

    def before_project(self, ctx: Context, project: Project) -> None:
        config = project.config("home.yml", HomeConfig)
        if config is None:
            return
        for directory in config.directories:
            self._create_directory(ctx, directory)

    def run_project(self, ctx: Context, project: Project) -> None:
        config = project.config("home.yml", HomeConfig)
        if config is None:
            return
        for file in config.files:
            self._install_file(ctx, project, file)

    def _create_directory(self, ctx: Context, directory: HomeDirectory) -> None:
        dest = ctx.home / directory.path

        print(f"Checking if ~/{directory.path} exists ... ", end="")
        if dest.is_dir():
            print("yes")
        else:
            print("no")
            print(f"Creating directory ~/{directory.path}")
            dest.mkdir(parents=True, exist_ok=True)

        if directory.mode is not None:
            current = oct(stat.S_IMODE(dest.stat().st_mode))[2:]
            print(f"Checking if the permissions of ~/{directory.path} are {directory.mode} ... ", end="")
            if current == directory.mode:
                print("yes")
            else:
                print("no")
                print(f"Change the permissions of ~/{directory.path} to {directory.mode}")
                dest.chmod(int(directory.mode, 8))

    def _install_file(self, ctx: Context, project: Project, file: HomeFile) -> None:
        spec = file.spec
        dest = ctx.home / spec.path
        dest.parent.mkdir(parents=True, exist_ok=True)

        if isinstance(spec, OpSpec):
            print(f"> op read {spec.ref} > ~/{spec.path}")
            content = subprocess.run(["op", "read", spec.ref], stdout=subprocess.PIPE, check=True).stdout
            if not content:
                raise RuntimeError(f"op read {spec.ref} produced an empty file")
            dest.write_bytes(content)
            if spec.mode is not None:
                dest.chmod(int(spec.mode, 8))
        elif isinstance(spec, InfisicalSpec):
            print(f"> infisical secrets get {spec.name} --projectId={spec.project_id} --env={spec.env} > ~/{spec.path}")
            content = subprocess.run(
                [
                    "infisical", "secrets", "get", spec.name,
                    "--projectId", spec.project_id,
                    "--env", spec.env,
                    "--plain", "--silent",
                ],
                stdout=subprocess.PIPE,
                check=True,
            ).stdout
            if not content:
                raise RuntimeError(f"infisical secrets get {spec.name} produced an empty file")
            dest.write_bytes(content)
            if spec.mode is not None:
                dest.chmod(int(spec.mode, 8))
        elif isinstance(spec, FileSpec):
            src = project.resources_dir / "home" / spec.path
            dest.unlink(missing_ok=True)
            if spec.strategy == "copy":
                print(f"> cp {src} ~/{spec.path}")
                shutil.copy2(src, dest)
                if spec.mode is not None:
                    dest.chmod(int(spec.mode, 8))
            else:
                print(f"> ln -s {src} ~/{spec.path}")
                dest.symlink_to(src)
        else:
            raise ValueError(f"unexpected home file spec type: {type(spec)!r}")
