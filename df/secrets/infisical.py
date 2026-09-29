"""Infisical secret fetching.

Returns the secret's raw bytes and raises ``RuntimeError`` if the underlying
command produces empty output, so a misconfigured secret reference never
silently overwrites something with nothing.

When ``infisical secrets get`` fails, the login state is checked and — if the
failure is due to not being logged in — ``infisical login`` is launched
interactively, then the fetch is retried. Failures for any other reason (e.g. a
wrong project_id) are surfaced without launching login.
"""

from __future__ import annotations

import subprocess
import sys


def _infisical_secrets_get(name: str, project_id: str, env: str) -> subprocess.CompletedProcess[bytes]:
    # stderr はリダイレクトせず端末にそのまま出す(失敗時に infisical のエラーが見える)
    return subprocess.run(
        [
            "infisical", "secrets", "get", name,
            "--projectId", project_id,
            "--env", env,
            "--plain", "--silent",
        ],
        stdout=subprocess.PIPE,
    )


def _infisical_logged_in() -> bool:
    return subprocess.run(
        ["infisical", "login", "status"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    ).returncode == 0


def _infisical_login() -> None:
    print("Infisical にログインしていません。`infisical login` を実行します。")
    if not sys.stdin.isatty():
        raise RuntimeError(
            "infisical login が必要です。`infisical login` を実行してから再実行してください。"
        )
    subprocess.run(["infisical", "login"])  # stdio をそのまま継承 = 対話ログイン可
    if not _infisical_logged_in():
        raise RuntimeError("infisical login に失敗しました。")


def infisical_get(name: str, project_id: str, env: str) -> bytes:
    result = _infisical_secrets_get(name, project_id, env)
    if result.returncode != 0:
        if _infisical_logged_in():
            # 認証以外の失敗(project_id 誤りなど)。ログインを促さずそのまま伝える。
            raise RuntimeError(f"infisical secrets get {name} failed (exit {result.returncode})")
        _infisical_login()
        result = _infisical_secrets_get(name, project_id, env)
        if result.returncode != 0:
            raise RuntimeError(
                f"infisical secrets get {name} failed (exit {result.returncode}) even after logging in"
            )
    if not result.stdout:
        raise RuntimeError(f"infisical secrets get {name} produced an empty file")
    return result.stdout
