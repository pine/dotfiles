"""Personal dotfiles installer.

Phase 1 of the bash -> uv/Python migration: the orchestration (config
reading, task ordering, dispatch, timing) lives here in Python, while the
individual tasks remain bash functions executed through a thin runner shim.
See CLAUDE.md for the overall architecture.
"""
