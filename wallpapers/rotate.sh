#!/usr/bin/env bash

# Alterna wallpapers aleatoriamente a cada N minutos
WALLPAPER_DIR="$HOME/wallpapers"
INTERVAL=${1:-300}  # padrao: 5 minutos

while true; do
    wallpaper=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n 1)
    if [[ -n "$wallpaper" ]]; then
        feh --bg-fill "$wallpaper"
    fi
    sleep "$INTERVAL"
done
