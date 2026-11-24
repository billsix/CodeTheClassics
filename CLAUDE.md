# CodeTheClassics — context for Claude

Ten faithful GLFW + OpenGL 3.3 core ports of the *Code the Classics* games (11 files: boing also has `boing_gl1.py`), under `vol1/`
and `vol2/`. Moved on 2026-11-24 from the course repository (`github.com/billsix/modelviewprojection`, "mvp" in the reference
docs; kept unchanged for history, successor `github.com/billsix/Programming3DComputerGraphics`) with their history. Each game is ONE
file that owns its loop and inlines its engine (renderer, shaders, `Actor`, input); what every game shares is the top-level package
`pgzero_gl/` (`audio`, `resources`, `gl`; LGPL-2.1). Behaviour-faithful (same RNG, update and draw order), structure-free. The
only dependency outside this repository is `gacalc` (`github.com/billsix/geometricalgebra`, pinned in `requirements.txt`).

- **Read `tasks/reference/code-the-classics-tightening.md` before editing any game**: the file-shape standard, the gacalc dialect
  (`length`→`magnitude`, `dot`→`scalar_product`, `rotate(deg)`→`plane_rotation`, …), the composition `@`-vs-`compose` rule.
  Also here: `coordinate-spaces-in-code-the-classics.md`, `pgzero-gl-design-for-a-personal-learning-library.md`,
  `gacalc-transforms-in-the-renderer.md`, `point-type-decision.md`, and `gates-and-verification.md`.
- **Gates** (`tasks/reference/gates-and-verification.md`): `tools/ctc_verify_game.sh` (frame pixel identity vs a git ref),
  `tools/ctc_state_trace.py` + `tools/ctc_compare_traces.py` (seeded scripted-input trace), `tools/ctc_gate_all.sh` (both on every
  game), `tools/ctc_profile_update.py` when something feels slow. They need an Xvfb on `:99` and the `codetheclassics` image. Audio
  and the gamepad are never gated: play-test.
- **A game cannot be imported as a module**: it calls `sys.exit` when imported, just before it opens a window. `make check`
  (`tools/check_imports.py`) relies on that.
- **gacalc vectors are FROZEN**: change a coordinate by rebinding, never in place. `ty` catches `v.x = …` but not `v.x += …`, so a
  grep for `\.(x|y|z)\s*[-+*/]?=` is part of any audit after a bulk edit.
- **Container:** `make image|shell|shell-exec|run GAME=vol1/boing|check|format|update-pins`; the repository is mounted at `/ctc`, and
  `entrypoint/shell.sh` puts it on `PYTHONPATH` so `pgzero_gl` resolves when a game runs by path.
- **Python standard:** the portable rules are `runClaudeInContainer/tasks/reference/python-coding-standard.md`
  (github.com/billsix/runClaudeInContainer); a green `make format` is the mechanical tier. Line length is 80, with E501 ignored in
  the games, `pgzero_gl/`, `tools/`.
- **Assets** (`images/`, `sounds/`, `music/`, tilemaps) are upstream's and are committed deliberately; see the licence note in
  `README.md`. Reference docs cite paths such as `tasks/archive/...` that name the course repository's history, not this one.

## Tasks

Work lives in `tasks/`; completed work moves to `tasks/archive/<YYYY>/<MM>/<DD>/`. The move into this repository:
`tasks/archive/2026/11/24/extract-code-the-classics-to-own-repo.md`.
