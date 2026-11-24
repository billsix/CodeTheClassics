#!/usr/bin/env bash
#
# 02-install-graphics.sh -- a software OpenGL stack and a virtual X server, so every game can be started without a
# display (llvmpipe through Mesa, Xvfb) and its window captured, plus the Wayland, EGL and sound client libraries GLFW,
# PyOpenGL and miniaudio load. No options.
set -uo pipefail

dnf install -y --skip-unavailable \
    alsa-lib \
    libdecor \
    libwayland-client \
    libwayland-cursor \
    libwayland-egl \
    libxkbcommon \
    mesa-dri-drivers \
    mesa-libEGL \
    mesa-libGL \
    pulseaudio-libs \
    xdpyinfo \
    xorg-x11-server-Xvfb \
    openbox
