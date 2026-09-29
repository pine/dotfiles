"""Base class for Python tasks.

A task has three phases -- ``before`` -> ``run`` -> ``after`` -- and each phase
comes in two forms: a whole-task hook and a per-project hook (``*_project``,
which receives one ``Project``). Within a phase the orchestrator calls the
whole-task hook first, then the per-project hook once for each project
(main/secure/work). Every hook defaults to an empty implementation, so a task
overrides only the few it needs -- e.g. a task that just processes one config
file per project overrides only ``run_project``.
"""

from __future__ import annotations

from df.context import Context, Project


class Task:
    """A single migrated task. Subclasses set ``name`` and override hooks."""

    name: str

    def before(self, ctx: Context) -> None:
        pass

    def before_project(self, ctx: Context, project: Project) -> None:
        pass

    def run(self, ctx: Context) -> None:
        pass

    def run_project(self, ctx: Context, project: Project) -> None:
        pass

    def after(self, ctx: Context) -> None:
        pass

    def after_project(self, ctx: Context, project: Project) -> None:
        pass
