#!/usr/bin/env bash
#
# Run every game headless: each under Xvfb and Mesa's software renderer for PGZERO_MAX_FRAMES frames (default 120), then check
# that it exited 0. Run inside the container:   make shell-exec SCRIPT=tools/run_games_xvfb.sh      (FRAMES=60 to shorten)
# Prints one line per game and exits nonzero if any game failed or timed out. Writes build/games-run/<game>.log.
set -uo pipefail
repo="$(cd "$(dirname "$0")/.." && pwd)"
frames="${FRAMES:-120}"
export LIBGL_ALWAYS_SOFTWARE=1 DISPLAY=:96 PGZERO_MAX_FRAMES="$frames"
unset WAYLAND_DISPLAY
Xvfb :96 -screen 0 1280x720x24 +extension GLX >/dev/null 2>&1 &
xvfb=$!
sleep 2
mkdir -p "$repo/build/games-run"
status=0
for path in "$repo"/vol*/*/*.py; do
    name="$(basename "$path" .py)"
    start=$SECONDS
    timeout 180 "$repo/tools/run_game.sh" "$(basename "$(dirname "$(dirname "$path")")")/$(basename "$(dirname "$path")")/$name" \
        >"$repo/build/games-run/$name.log" 2>&1
    code=$?
    if [ "$code" -eq 0 ]; then result=ok; else result="FAIL($code)"; status=1; fi
    printf '%-12s %-8s %3ds\n' "$name" "$result" $((SECONDS - start))
done
kill "$xvfb" 2>/dev/null
exit $status
