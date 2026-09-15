"""Task orchestration entry point.

Decides which tasks to run, then runs each one through its phases. The task
registry (``df.tasks.PYTHON_TASKS``) is the single source of truth for both
the set of known task names and the order they run in; CLI arguments only
narrow that set down.
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


def select_tasks(argv: list[str]) -> list[Task]:
    """Pick the tasks to run, always in ``PYTHON_TASKS`` registry order.

    No arguments selects every task. Arguments select by name: they narrow the
    set but never reorder it, because the registry order encodes undeclared
    dependencies between tasks (``brew`` installs the fish binary that ``fish``
    then configures; ``home`` deploys the files that ``script`` reads). An
    unknown name is a hard error -- the registry lists every valid name, so a
    name outside it can only be a typo, and skipping it silently would report
    success without having done the work.
    """
    if not argv:
        return list(PYTHON_TASKS)

    known = {task.name for task in PYTHON_TASKS}
    unknown = [name for name in argv if name not in known]
    if unknown:
        available = " ".join(task.name for task in PYTHON_TASKS)
        print(f"ERROR: unknown task: {' '.join(unknown)}", file=sys.stderr)
        print(f"Available tasks: {available}", file=sys.stderr)
        raise SystemExit(2)

    selected = set(argv)
    return [task for task in PYTHON_TASKS if task.name in selected]


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

    # Validate before printing the banner: a typo must not look like a run.
    tasks = select_tasks(sys.argv[1:])

    print("Started installing")
    begin = time.time()

    root = repo_root()
    os.chdir(root)

    with tempfile.TemporaryDirectory(prefix="dotfiles.") as tmp:
        ctx = build_context(
            root=root,
            secured_root=root / "secured",
            corporate_root=CORPORATE_DIR,
            tmp_dir=Path(tmp),
        )
        for task in tasks:
            run_task(task, ctx)

    elapsed = int(time.time() - begin)
    print("\n\033[32msuccess\033[39m")
    print(f"✨  Done in {elapsed}s.")
    return 0
