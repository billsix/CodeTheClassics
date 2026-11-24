# Checks and behaviour gates for the games

**Reference document.** What each check proves, what it needs, and what no check covers. Not a task; update in place. Written
2026-11-24 when the games moved here from the course repository; the earlier gate history is in that repository's
`tasks/reference/tests-and-gates.md` (section 3, "Code-the-Classics behaviour gates", and the smoke-test note in section 4).

## The checks, cheapest first

| Check | Command | Proves | Needs |
|---|---|---|---|
| Format, lint, types | `make format` | ruff clean and idempotent, `ty` clean on `vol1`, `vol2`, `pgzero_gl` | the image |
| Imports and tests | `make check` | every game and `pgzero_gl` import (a game stops at its own "run me directly" exit), `tests/test_ctc_actor_field_collisions.py` passes | the image, no display |
| Headless run | `make shell-exec` with `Xvfb`, `PGZERO_MAX_FRAMES=120 python vol2/eggzy/eggzy.py` | the game opens a window, draws 120 frames and closes with exit 0 | the image, Xvfb |
| Frame identity | `tools/ctc_verify_game.sh <game.py> [frame] [ref]` | frame N is pixel-identical to the same file at git ref `ref` (default `HEAD`); the baseline is captured twice first, so a game that is not reproducible cannot pass | podman and Xvfb `:99` on the host, the image |
| State trace | `tools/ctc_state_trace.py` + `tools/ctc_compare_traces.py` | a scripted key sequence drives `update()` and the whole `game` object graph matches the baseline frame by frame (covers the input paths the frame gate cannot see, which only sees attract mode) | the same |
| Both, every game | `tools/ctc_gate_all.sh [game ...]` | the two gates on each game against `REF` (default `master`) | the same |
| Slow update | `tools/ctc_profile_update.py` | where `update()` spends its time | the image |

## Facts that save a debugging session

- **A game exits on import.** Just before it opens a window it runs `sys.exit("this is a game, run it directly rather than
  importing it")` when `__name__ != "__main__"`. A tool that imports a game (`tools/check_imports.py`) catches exactly that exit.
  The capture tools use `runpy` to run a game as `__main__` with its loop bounded by `PGZERO_MAX_FRAMES`.
- **Captures are tied to the frame count, not the clock**: `tools/ctc_capture_frame.py` seeds `random` before the game runs and
  reads the back buffer on the Nth `glfw.swap_buffers`. A capture that times out on the unchanged baseline is a flake (seen once,
  `avenger`, 2026-11-15): re-run that game alone.
- **Baselines written against another import path:** `BASELINE_SRC=<directory containing a modelviewprojection/ package>` runs the
  baseline captures with that directory on `PYTHONPATH`. This is how the move from `modelviewprojection.pgzero_gl` to `pgzero_gl` was
  proved on 2026-11-24 (see the archived task). Unset for ordinary edits.
- **EGL capture, should a pbuffer ever be wanted:** set both `PYOPENGL_PLATFORM=egl` and `EGL_PLATFORM=surfaceless` before
  `from OpenGL import …`, or PyOpenGL binds GLX and every call raises "no valid context".

## Not covered

Audio (the software mixer in `pgzero_gl/audio.py`) and gamepad input are never gated; play-test them. The frame gate sees
attract mode only; the state trace sees only the keys its script presses.
