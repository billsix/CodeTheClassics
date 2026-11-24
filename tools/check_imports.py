"""Import every game and the shared package, with no display and no GL context.

A game is a program, not a module: just before it opens its window it runs
``sys.exit("this is a game, run it directly rather than importing it")`` when
it was imported. Importing a game therefore runs everything above that line
(the imports, the engine classes, the constants) and stops there, which proves
that the imports resolve (glfw, PyOpenGL, numpy, imageio, miniaudio, gacalc,
``pgzero_gl``) and that the definitions execute. The check treats exactly that
exit as success; the shared package imports normally.

Usage:
    python3 tools/check_imports.py          # every game and pgzero_gl
    python3 tools/check_imports.py eggzy    # only paths containing the text
"""

import importlib.util
import pathlib
import sys
import traceback
import types

REPO: pathlib.Path = pathlib.Path(__file__).resolve().parents[1]
GAME_EXIT_MESSAGE: str = (
    "this is a game, run it directly rather than importing it"
)


def import_module_from_path(path: pathlib.Path) -> None:
    """Import one source file under a name unique to its path.

    Args:
        path: The ``.py`` file to import.

    Raises:
        Exception: Whatever the module raises while importing, other than
            a game's own "run me directly" exit.
    """
    relative: pathlib.Path = path.relative_to(REPO).with_suffix("")
    name: str = "ctc_" + "_".join(relative.parts)
    spec: importlib.machinery.ModuleSpec | None = (
        importlib.util.spec_from_file_location(name, path)
    )
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module: types.ModuleType = importlib.util.module_from_spec(spec)
    try:
        spec.loader.exec_module(module)
    except SystemExit as stop:
        if stop.code != GAME_EXIT_MESSAGE:
            raise


def main() -> int:
    """Import every module and report the failures.

    Returns:
        ``0`` when every module imported, ``1`` otherwise.
    """
    sys.path.insert(0, str(REPO))
    pattern: str = sys.argv[1] if len(sys.argv) > 1 else ""
    paths: list[pathlib.Path] = sorted(
        path
        for path in [*REPO.glob("vol*/*/*.py"), *REPO.glob("pgzero_gl/*.py")]
        if pattern in path.as_posix()
    )
    failures: list[pathlib.Path] = []
    for path in paths:
        try:
            import_module_from_path(path)
        except Exception:
            failures.append(path)
            print(f"FAIL {path.relative_to(REPO)}")
            traceback.print_exc(limit=3)
    print(f"{len(paths) - len(failures)} of {len(paths)} modules imported")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
