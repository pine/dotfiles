"""YAML config loading shared by the Python task layer.

Uses PyYAML. Kept in one place so every task loads config the same way and
missing files are handled uniformly.
"""

from __future__ import annotations

from pathlib import Path
from typing import Any

import yaml


def load_yaml(path: Path) -> Any | None:
    """Parse a YAML file, or return ``None`` when it does not exist.

    An existing but empty file parses to ``None`` as well (PyYAML behaviour),
    so callers should treat ``None`` as "nothing to do".
    """
    if not path.is_file():
        return None
    with path.open(encoding="utf-8") as f:
        return yaml.safe_load(f)
