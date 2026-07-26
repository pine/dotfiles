"""Script task: run one-off setup scripts declared per project.

Ported from tasks/script.bash. Each project's ``config/script/files.yml``
lists script names under ``files``; for each name, ``resources/script/<name>.sh``
is executed if present, with ``ENV_NAME`` set in its environment.

Config schema (validated by the models below)::

    files:
      - name: bats
      - name: rustup
"""

from __future__ import annotations

import subprocess

from pydantic import BaseModel, ConfigDict

from df.context import Context, Project
from df.tasks.base import Task


class ScriptFile(BaseModel):
    model_config = ConfigDict(extra="forbid")

    name: str


class ScriptConfig(BaseModel):
    model_config = ConfigDict(extra="forbid")

    files: list[ScriptFile] = []


class ScriptTask(Task):
    name = "script"

    def run_project(self, ctx: Context, project: Project) -> None:
        config = project.config("script/files.yml", ScriptConfig)
        if config is None:
            return
        for file in config.files:
            self._run_script(ctx, project, file.name)

    def _run_script(self, ctx: Context, project: Project, name: str) -> None:
        script = project.resources_dir / "script" / f"{name}.sh"
        if not script.is_file():
            return

        print(f"Running {name}.sh")
        script_env = {**ctx.os_environ, "ENV_NAME": ctx.env}
        subprocess.run([str(script)], env=script_env, cwd=ctx.root, check=True)
