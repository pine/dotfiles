"""Task orchestration entry point.

Replaces the control flow that used to live in bin/install.sh: it computes the
environment variables the tasks expect, decides which tasks to run and in what
order, and dispatches each (task, action) to the bash runner shim.
"""

from __future__ import annotations

import os
import subprocess
import sys
import tempfile
import time
from pathlib import Path

# Actions attempted for every task, in order (matches the old installer).
ACTIONS = ("preinstall", "install", "postinstall")

# Corporate dotfiles repo location (was DF_CORPORATE_DIR in install.sh).
CORPORATE_DIR = Path.home() / "project" / "kazuki-matsushita" / "dotfiles-work"


def repo_root() -> Path:
    """Repository root (the parent of the ``df`` package)."""
    return Path(__file__).resolve().parent.parent


def build_env(root: Path, tmp_dir: Path) -> dict[str, str]:
    """Environment variables shared with every bash task.

    Mirrors the ``declare -r`` block at the top of the old bin/install.sh so the
    bash tasks and init scripts see exactly the same variables.
    """
    secured = root / "secured"
    env = os.environ.copy()

    env["LANG"] = env["LANGUAGE"] = env["LC_ALL"] = "en_US.UTF-8"

    # Root / temp
    env["DF_ROOT_DIR"] = str(root)
    env["DF_ROOT"] = str(root)  # deprecated alias, kept for parity
    env["DF_TMP_DIR"] = str(tmp_dir)

    # Repo layout
    env["DOTFILES_CONFIG"] = str(root / "config")  # deprecated alias
    env["DOTFILES_RESOURCES"] = str(root / "resources")
    env["DOTFILES_TASKS"] = str(root / "tasks")
    env["DF_CONFIG_DIR"] = str(root / "config")
    env["DF_RESOURCES_DIR"] = str(root / "resources")
    env["DF_FUNC_DIR"] = str(root / "functions")
    env["DF_INIT_DIR"] = str(root / "init")
    env["DF_VENDOR_DIR"] = str(root / "vendor")

    # Secured submodule
    env["DOTFILES_SECURED_ROOT"] = str(secured)  # deprecated alias
    env["DOTFILES_SECURED_CONFIG"] = str(secured / "config")  # deprecated alias
    env["DOTFILES_SECURED_RESOURCES"] = str(secured / "resources")  # deprecated
    env["DOTFILES_SECURED_TASKS"] = str(secured / "tasks")
    env["DF_SECURE_ROOT_DIR"] = str(secured)
    env["DF_SECURE_CONFIG_DIR"] = str(secured / "config")
    env["DF_SECURE_RESOURCES_DIR"] = str(secured / "resources")

    # Corporate dotfiles
    env["DF_CORPORATE_DIR"] = str(CORPORATE_DIR)
    env["DF_CORPORATE_CONFIG_DIR"] = str(CORPORATE_DIR / "config")
    env["DF_CORPORATE_RESOURCES_DIR"] = str(CORPORATE_DIR / "resources")

    return env


def _read_task_lines(path: Path) -> list[str]:
    """Read a tasks.conf, dropping blank lines and comments."""
    if not path.is_file():
        return []
    tasks: list[str] = []
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        tasks.append(line)
    return tasks


def construct_tasks(env: dict[str, str], argv: list[str]) -> list[str]:
    """Determine the ordered task list.

    Explicit CLI args win; otherwise read the repo tasks.conf followed by the
    secured tasks.conf (matches _dotfiles_construct_tasks).
    """
    if argv:
        return argv

    tasks = _read_task_lines(Path(env["DOTFILES_CONFIG"]) / "tasks.conf")
    tasks += _read_task_lines(Path(env["DOTFILES_SECURED_CONFIG"]) / "tasks.conf")
    return tasks


def run_task(root: Path, env: dict[str, str], task: str, action: str) -> None:
    """Dispatch a single (task, action) to the bash runner shim."""
    runner = root / "bin" / "run_task.bash"
    subprocess.run(["bash", str(runner), task, action], env=env, check=True)


def main() -> int:
    # Line-buffer stdout so our prints interleave correctly with the output of
    # the bash subprocesses (which write to the same fd directly).
    sys.stdout.reconfigure(line_buffering=True)

    print("Started installing")
    begin = time.time()

    root = repo_root()
    os.chdir(root)

    with tempfile.TemporaryDirectory(prefix="dotfiles.") as tmp:
        tmp_dir = Path(tmp)
        env = build_env(root, tmp_dir)

        print(f"DF_ROOT_DIR: {root}")
        print(f"DF_TMP_DIR: {tmp_dir}")

        tasks = construct_tasks(env, sys.argv[1:])

        for task in tasks:
            for action in ACTIONS:
                run_task(root, env, task, action)

    elapsed = int(time.time() - begin)
    print("\n\033[32msuccess\033[39m")
    print(f"✨  Done in {elapsed}s.")
    return 0
