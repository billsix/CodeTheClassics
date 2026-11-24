#!/usr/bin/env bash
#
# Run one game: tools/run_game.sh vol1/boing   (or vol1/boing/boing, or vol1/boing/boing_gl1)
# Finds <vol>/<game>/<game>.py, or the .py named by the third path component. Run inside the container
# (make run GAME=vol1/boing), where /venv is active and the repository root is on PYTHONPATH.
set -uo pipefail
repo="$(cd "$(dirname "$0")/.." && pwd)"
game="${1:?usage: run_game.sh <vol>/<game>[/<file>], e.g. vol1/boing}"
IFS=/ read -r vol name file <<<"$game"
path="$repo/$vol/$name/${file:-$name}.py"
[ -f "$path" ] || { echo "no such game: $game (make list shows them)" >&2; exit 2; }
export PYTHONPATH="$repo${PYTHONPATH:+:$PYTHONPATH}"
exec python "$path"
