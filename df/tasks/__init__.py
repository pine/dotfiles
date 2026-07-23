"""Python task registry.

``PYTHON_TASKS`` is the ordered list of migrated tasks; the orchestrator runs
them in this order (each running preinstall -> install -> postinstall). To add
a task, implement a ``Task`` subclass and append it here.
"""

from __future__ import annotations

from df.tasks.base import Task
from df.tasks.git import GitTask

PYTHON_TASKS: list[Task] = [
    GitTask(),
]
