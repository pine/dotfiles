"""Task registry.

``PYTHON_TASKS`` is the ordered list of tasks; the orchestrator runs them in
this order (each running before -> run -> after). To add a task, implement a
``Task`` subclass and insert it at the right position in the list below -- the
order is significant (see the comment above the list).
"""

from __future__ import annotations

from df.tasks.base import Task
from df.tasks.brew import BrewTask
from df.tasks.fish import FishTask
from df.tasks.git import GitTask
from df.tasks.gpg import GpgTask
from df.tasks.home import HomeTask
from df.tasks.mas import MasTask
from df.tasks.script import ScriptTask

# The order below is the one the pre-Python installer used (the former
# config/tasks.conf), and it encodes dependencies the tasks do not declare:
# `brew` first because it installs the binaries the later tasks shell out to
# (mas, gnupg, infisical, fish), `home` before `fish`/`script` because it
# deploys the files they read (fish_plugins, the scripts' inputs).
PYTHON_TASKS: list[Task] = [
    BrewTask(),
    MasTask(),
    HomeTask(),
    FishTask(),
    GitTask(),
    ScriptTask(),
    GpgTask(),
]
