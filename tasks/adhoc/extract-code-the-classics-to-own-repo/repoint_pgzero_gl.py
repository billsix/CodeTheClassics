"""Repoint the games at the top-level ``pgzero_gl`` package.

One-shot codemod for the move of ``pgzero_gl`` out of ``modelviewprojection``: every
``modelviewprojection.pgzero_gl`` in a game or in the package's own docs becomes
``pgzero_gl``. Idempotent: a second run changes nothing. Paths are relative to the
repository root.

Usage:
    python3 tasks/adhoc/extract-code-the-classics-to-own-repo/repoint_pgzero_gl.py
"""

import pathlib

REPO: pathlib.Path = pathlib.Path(__file__).resolve().parents[3]
OLD: str = "modelviewprojection.pgzero_gl"
NEW: str = "pgzero_gl"


def main() -> None:
    """Rewrite the games and the package, then report the counts."""
    changed: list[str] = []
    sites: int = 0
    paths: list[pathlib.Path] = sorted(
        [*REPO.glob("vol*/**/*.py"), *REPO.glob("pgzero_gl/*.py")]
    )
    for path in paths:
        before: str = path.read_text()
        after: str = before.replace(OLD, NEW)
        if after != before:
            sites += before.count(OLD)
            path.write_text(after)
            changed.append(path.relative_to(REPO).as_posix())
    print(f"changed {len(changed)} files, {sites} sites")


if __name__ == "__main__":
    main()
