"""Task orchestration entry point.

Decides which tasks to run, then runs each one through its phases. The task
registry (``df.tasks.PYTHON_TASKS``) is the single source of truth for the
order tasks run in.
"""

from __future__ import annotations

import os
import sys
import tempfile
import time
from pathlib import Path

from df.context import Context, build_context
from df.tasks import PYTHON_TASKS
from df.tasks.base import Task

# Corporate dotfiles repo location.
CORPORATE_DIR = Path.home() / "project" / "bm-sms" / "xuan-care-matsushita-misc" / "dotfiles"


def repo_root() -> Path:
    """Repository root (the parent of the ``df`` package)."""
    return Path(__file__).resolve().parent.parent


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


def construct_tasks(root: Path, argv: list[str]) -> list[str]:
    """Determine the selected task names.

    Explicit CLI args win; otherwise read the repo tasks.conf followed by the
    secured tasks.conf.
    """
    if argv:
        return argv

    tasks = _read_task_lines(root / "config" / "tasks.conf")
    tasks += _read_task_lines(root / "secured" / "config" / "tasks.conf")
    return tasks


def run_task(task: Task, ctx: Context) -> None:
    """Run one task through its three phases.

    Per phase the whole-task hook runs first, then the per-project hook once
    for each project (see df/tasks/base.py for the contract).
    """
    print(f"==> {task.name}: start")

    task.before(ctx)
    for project in ctx.projects:
        task.before_project(ctx, project)

    task.run(ctx)
    for project in ctx.projects:
        task.run_project(ctx, project)

    task.after(ctx)
    for project in ctx.projects:
        task.after_project(ctx, project)

    print(f"==> {task.name}: done")


def main() -> int:
    # Line-buffer stdout so our prints interleave correctly with the output of
    # the subprocesses tasks spawn (brew/git/mas/curl write to the same fd
    # directly). Matters when stdout is a pipe, e.g. `./bin/install.sh | tee`.
    sys.stdout.reconfigure(line_buffering=True)

    print("Started installing")
    begin = time.time()

    root = repo_root()
    os.chdir(root)

    selected = set(construct_tasks(root, sys.argv[1:]))

    with tempfile.TemporaryDirectory(prefix="dotfiles.") as tmp:
        ctx = build_context(
            root=root,
            secured_root=root / "secured",
            corporate_root=CORPORATE_DIR,
            tmp_dir=Path(tmp),
        )
        for task in PYTHON_TASKS:
            if task.name not in selected:
                continue
            run_task(task, ctx)

    elapsed = int(time.time() - begin)
    print("\n\033[32msuccess\033[39m")
    print(f"✨  Done in {elapsed}s.")
    return 0
