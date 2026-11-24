#!/usr/bin/env bash
#
# Format and lint the games, the shared package, the tools and the tests with ruff (settings in pyproject.toml).
# Portable: runs in the container (source mounted at /ctc) and on the host from anywhere. Every step runs and any
# failure is remembered, so one run reports all the red; exits nonzero if any failed.
if [ -d /ctc/pgzero_gl ]; then
    cd /ctc
else
    root=$(git rev-parse --show-toplevel 2>/dev/null) && [ -n "$root" ] && cd "$root"
fi
[ -f /venv/bin/activate ] && source /venv/bin/activate
status=0
paths=(vol1 vol2 pgzero_gl tools tests tasks/adhoc)
ruff check "${paths[@]}" --fix || status=1
ruff format "${paths[@]}" || status=1
ty check vol1 || status=1
ty check vol2 || status=1
ty check pgzero_gl || status=1
exit $status
