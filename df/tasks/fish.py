"""Fish task: install/update the fisher plugin manager and set fish as the
default login shell.

Ported from tasks/fish.bash. Unlike the other ported tasks this one has no
per-project config file -- it's a single machine-wide procedure (fisher +
default shell), so it implements only the whole-task ``run`` hook.
"""

from __future__ import annotations

import os
import shutil
import subprocess
from pathlib import Path

from df.context import Context
from df.tasks.base import Task
from df.tasks.brew import HOMEBREW_BIN_DIR

FISHER_URL = "https://git.io/fisher"


class FishTask(Task):
    name = "fish"

    def run(self, ctx: Context) -> None:
        if shutil.which("fish") is None:
            return
        self._install_fisher(ctx)
        if not os.environ.get("CI"):
            self._set_default_shell(ctx)

    def _install_fisher(self, ctx: Context) -> None:
        fisher_path = ctx.home / ".config" / "fish" / "functions" / "fisher.fish"
        print("Checking if fisher is installed ... ", end="")
        if fisher_path.is_file():
            print("yes")
        else:
            print("no")
            fisher_path.parent.mkdir(parents=True, exist_ok=True)
            subprocess.run(["curl", "-Lo", str(fisher_path), FISHER_URL], check=True)

        print("Checking fisher version")
        subprocess.run(["fish", "--login", "-c", "fisher -v"], check=True)
        print("Updating fisher plugins")
        subprocess.run(["fish", "--login", "-c", "fisher update"], check=True)

    def _set_default_shell(self, ctx: Context) -> None:
        fish_path = HOMEBREW_BIN_DIR / "fish"

        shells = Path("/etc/shells").read_text().splitlines()
        if str(fish_path) not in shells:
            subprocess.run(
                ["sudo", "tee", "-a", "/etc/shells"],
                input=f"{fish_path}\n".encode(),
                stdout=subprocess.DEVNULL,
                check=True,
            )

        user = os.environ["USER"]
        result = subprocess.run(
            ["dscl", ".", "-read", f"/Users/{user}", "UserShell"],
            check=True, capture_output=True, text=True,
        )
        if str(fish_path) not in result.stdout:
            subprocess.run(["chsh", "-s", str(fish_path)], check=True)
