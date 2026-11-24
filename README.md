# Code the Classics — GLFW + OpenGL 3.3 ports

Ports of the *Code the Classics* games (Raspberry Pi Press) from **PyGame Zero** to **GLFW + OpenGL 3.3 core profile**. They
are faithful translations: the same RNG, update and draw order, one readable file per game. The games began in the course
repository `github.com/billsix/modelviewprojection` and moved here on 2026-11-24 with their history; that repository is kept
unchanged for history, and its successor is `github.com/billsix/Programming3DComputerGraphics`.

- **Vol 1:** boing (plus `boing_gl1.py`, the same game on fixed-function OpenGL 1.x), cavern, myriapod, bunner, soccer
- **Vol 2:** eggzy, avenger, beatstreets, kinetix, leadingedge

## Run a game

```sh
make run GAME=vol1/boing            # [HOST] play it in the container, on Wayland or X11
make run GAME=vol1/boing/boing_gl1  # [HOST] the fixed-function variant of boing
make list                           # [HOST] every game
make shell                          # [HOST] a shell in the container (the repo is mounted at /ctc)
```

Inside `make shell` (`[CONTAINER]`), `PGZERO_MAX_FRAMES=120 python vol2/eggzy/eggzy.py` closes the window after 120 frames.
Outside the container the games need `PYTHONPATH=.` so that they find the `pgzero_gl` package at the repository root.
Dependencies are pinned in `requirements.txt` and `constraints.txt` (`make update-pins` re-resolves them).

## Check a change

```sh
make check    # [HOST] import every game and pgzero_gl, then pytest (no display)
make format   # [HOST] ruff format and lint, then ty on vol1, vol2 and pgzero_gl
```

A game is a program, not a module: importing it runs everything above its window setup and then exits with
"this is a game, run it directly". `tools/check_imports.py` treats that exit as success.

Behaviour gates (the games are behaviour-faithful, so a change must draw the same pixels). Both start containers with podman, so
they need `make image` built and an X server on `:99` on the host:

```sh
tools/ctc_verify_game.sh vol1/boing/boing.py 180   # [HOST] frame 180 pixel-identical to HEAD?
tools/ctc_gate_all.sh boing eggzy                  # [HOST] frame gate and scripted-input state trace, named games (none = all)
```

> Audio and gamepad input are never gated: check them by playing the game. Details: `tasks/reference/gates-and-verification.md`.

## Layout

```
vol1/<game>/<game>.py   one game per file, with its own images/ sounds/ music/
vol2/<game>/<game>.py   (vol2 games also carry tilemaps/ and similar)
pgzero_gl/              the engine pieces every game shares: audio (software mixer), resources (Image, Loader), gl (shader and buffer helpers)
tools/                  ctc_* behaviour gates, check_imports.py, run_game.sh
tests/                  test_ctc_actor_field_collisions.py (AST guard)
tasks/reference/        the file-shape standard, coordinate spaces, pgzero_gl design, gates
```

Each game file reads top to bottom: its engine (renderer and shaders, `Actor`/`Rect`, keyboard and gamepad), then the game, then
the loop the game owns. The file shape and conventions are in `tasks/reference/code-the-classics-tightening.md`.

## Licensing and attribution

- **Game code:** BSD-2-Clause, © Eben Upton (vol 1 2019, vol 2 2024), per the upstream Debian packaging; full text and the
  engine-code terms in `LICENSE`.
- **`pgzero_gl/`:** LGPL-2.1 (`pgzero_gl/LICENSE`).
- **Graphics and audio:** © Raspberry Pi Press and the authors (graphics by Dan Malone; audio by Allister Brimble). They are
  committed here for educational use on the maintainer's authorization (2026-06-24, kept 2026-11-24).

> The upstream GitHub repositories ship no licence file. Before this repository is made public, confirm redistribution of the
> assets with Raspberry Pi Press.

Upstream sources:
- Vol 1: https://github.com/raspberrypipress/Code-the-Classics-Vol1
- Vol 2: https://github.com/raspberrypipress/Code-the-Classics-Vol2
- Book (vol 1): https://magazine.raspberrypi.com/books/code-the-classics-vol-I-2ed
- The Debian source tarballs named in `LICENSE` (`code-the-classics_0.3.tar.xz`, `code-the-classics-2_0.1.tar.xz` on `archive.raspberrypi.org`)
