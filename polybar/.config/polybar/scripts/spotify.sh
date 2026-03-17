#!/usr/bin/env bash

# Mostra musica atual do Spotify via playerctl
player="spotify"

if ! playerctl -p "$player" status &>/dev/null; then
    echo ""
    exit 0
fi

status=$(playerctl -p "$player" status 2>/dev/null)
artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
title=$(playerctl -p "$player" metadata title 2>/dev/null)

if [[ "$status" == "Playing" ]]; then
    icon=""
elif [[ "$status" == "Paused" ]]; then
    icon=""
else
    echo ""
    exit 0
fi

# Limita tamanho pra nao estourar a bar
text="$artist - $title"
if [[ ${#text} -gt 40 ]]; then
    text="${text:0:37}..."
fi

echo "$icon $text"
