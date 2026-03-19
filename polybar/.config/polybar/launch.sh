#!/usr/bin/env bash

# Encerra instancias anteriores do polybar
killall -q polybar

# Aguarda os processos morrerem
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Lanca polybar em todos os monitores
if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload main &
    done
else
    polybar --reload main &
fi

# Reinicia apps de tray para re-registrar icones no novo polybar
sleep 1
if pgrep -x copyq >/dev/null; then
    killall -q copyq
    copyq &
fi
