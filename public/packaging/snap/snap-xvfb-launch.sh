#!/bin/bash

LIBGL_DEBUG=verbose glxinfo

ps auxx | grep 'Xvfb' | grep -v grep

echo = Launching marble =

export SDL_VIDEODRIVER=x11

LIBGL_DEBUG=verbose marble &
FOPID=$!
sleep 10
kill ${FOPID}
wait ${FOPID}
echo Marble return code $?
cat ~/.local/share/marble/marble.log || echo No log file
