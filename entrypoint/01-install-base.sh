#!/usr/bin/env bash
#
# 01-install-base.sh -- install the always-needed Fedora packages: git and make, uv for the Python virtual environment,
# a C++ compiler with the Python headers (miniaudio has no wheel for the newest Python, so pip builds it), and
# ImageMagick for the frame-identity gate. One package group per script, no options; the same packages during
# `podman build` or on a bare Fedora host.
set -uo pipefail

if ! command -v dnf >/dev/null 2>&1; then
    echo "01-install-base.sh: needs 'dnf' (this installs Fedora packages), not found." >&2
    echo "Run on a Fedora host/guest, or inside the project's Fedora-based image." >&2
    exit 1
fi

status=0
dnf upgrade -y || status=1

# --skip-unavailable: skip a package missing from the enabled repos rather than failing the whole install.
dnf install -y --skip-unavailable \
    ImageMagick \
    gcc \
    gcc-c++ \
    git \
    libatomic \
    libffi-devel \
    make \
    python3-devel \
    tmux \
    uv \
    which || status=1

exit $status
