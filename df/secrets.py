"""Shared secret-fetching helpers, used by both the home and gpg tasks.

Each function returns the secret's raw bytes and raises ``RuntimeError`` if the
underlying command produces empty output, so a misconfigured secret reference
never silently overwrites something with nothing.
"""

from __future__ import annotations

import subprocess


def op_read(ref: str) -> bytes:
    content = subprocess.run(["op", "read", ref], stdout=subprocess.PIPE, check=True).stdout
    if not content:
        raise RuntimeError(f"op read {ref} produced an empty file")
    return content


def infisical_get(name: str, project_id: str, env: str) -> bytes:
    content = subprocess.run(
        [
            "infisical", "secrets", "get", name,
            "--projectId", project_id,
            "--env", env,
            "--plain", "--silent",
        ],
        stdout=subprocess.PIPE,
        check=True,
    ).stdout
    if not content:
        raise RuntimeError(f"infisical secrets get {name} produced an empty file")
    return content
