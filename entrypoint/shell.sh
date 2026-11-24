#!/usr/bin/env bash
set -e
cd /ctc/
# The games' virtual environment (python, ruff, ty, pytest), and the repository root on PYTHONPATH so the games find
# the top-level `pgzero_gl` package when run by path.
[ -f /venv/bin/activate ] && source /venv/bin/activate
export PYTHONPATH=/ctc${PYTHONPATH:+:$PYTHONPATH}
exec bash "$@"
