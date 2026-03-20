#!/usr/bin/env bash

# Mic toggle/status para polybar
# Click esquerdo: toggle mute/unmute

if [[ "$1" == "toggle" ]]; then
    amixer set Capture toggle > /dev/null 2>&1
fi

status=$(amixer sget Capture 2>/dev/null | /usr/bin/grep -o '\[on\]\|\[off\]' | head -1)

if [[ "$status" == "[off]" ]]; then
    echo "%{T2}%{T-}"
else
    echo "%{T2}%{T-}"
fi
