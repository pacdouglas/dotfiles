#!/bin/bash

# tmux-terminal.sh - abre kitty com tmux session ou foca se ja existe

SESSION_NAME="main-kitty-tmux-pac"

# Procura janela do kitty com a sessao tmux
WINDOW_ID=$(xdotool search --name "$SESSION_NAME" | head -1)

if [[ -n "$WINDOW_ID" ]]; then
    # Se existe, traz pro workspace atual e foca
    CURRENT_WS=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused) | .name')
    i3-msg "[id=$WINDOW_ID]" move workspace "$CURRENT_WS", focus
else
    # Garante que sessao tmux existe
    if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        tmux new-session -d -s "$SESSION_NAME"
    fi

    # Abre kitty conectando na sessao tmux
    kitty -o confirm_os_window_close=0 tmux attach-session -t "$SESSION_NAME" &
fi
