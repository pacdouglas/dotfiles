#!/usr/bin/env bash
# Posiciona monitor externo a direita do laptop quando conectado.
# Edite aqui se trocar a saida HDMI/DP ou o lado.

PRIMARY="eDP-1"
EXTERNAL="HDMI-1-0"

if xrandr --query | grep -q "^${EXTERNAL} connected"; then
    xrandr --output "$PRIMARY" --auto --primary \
           --output "$EXTERNAL" --auto --right-of "$PRIMARY"
else
    xrandr --output "$PRIMARY" --auto --primary
fi
