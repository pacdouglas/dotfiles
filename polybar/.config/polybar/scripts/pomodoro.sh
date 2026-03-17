#!/usr/bin/env bash

# Pomodoro timer pro polybar
# Click esquerdo: inicia/pausa
# Click direito: reseta

POMODORO_FILE="/tmp/polybar-pomodoro"
WORK_MIN=25
BREAK_MIN=5

start_pomodoro() {
    echo "$(date +%s) work running" > "$POMODORO_FILE"
}

stop_pomodoro() {
    rm -f "$POMODORO_FILE"
}

toggle_pomodoro() {
    if [[ ! -f "$POMODORO_FILE" ]]; then
        start_pomodoro
        exit 0
    fi

    read -r start_ts mode state < "$POMODORO_FILE"

    if [[ "$state" == "running" ]]; then
        elapsed=$(( $(date +%s) - start_ts ))
        echo "$elapsed $mode paused" > "$POMODORO_FILE"
    elif [[ "$state" == "paused" ]]; then
        elapsed=$start_ts
        new_start=$(( $(date +%s) - elapsed ))
        echo "$new_start $mode running" > "$POMODORO_FILE"
    fi
}

# Acoes via click
case "$1" in
    toggle) toggle_pomodoro; exit 0 ;;
    reset)  stop_pomodoro; exit 0 ;;
esac

# Display
if [[ ! -f "$POMODORO_FILE" ]]; then
    echo " off"
    exit 0
fi

read -r start_ts mode state < "$POMODORO_FILE"

if [[ "$mode" == "work" ]]; then
    total=$((WORK_MIN * 60))
else
    total=$((BREAK_MIN * 60))
fi

if [[ "$state" == "running" ]]; then
    elapsed=$(( $(date +%s) - start_ts ))
elif [[ "$state" == "paused" ]]; then
    elapsed=$start_ts
fi

remaining=$((total - elapsed))

if (( remaining <= 0 )); then
    # Troca de modo
    if [[ "$mode" == "work" ]]; then
        notify-send "Pomodoro" "Hora do break!" -u normal
        echo "$(date +%s) break running" > "$POMODORO_FILE"
        echo " break"
    else
        notify-send "Pomodoro" "Volta ao trabalho!" -u normal
        echo "$(date +%s) work running" > "$POMODORO_FILE"
        echo " work"
    fi
    exit 0
fi

minutes=$((remaining / 60))
seconds=$((remaining % 60))

if [[ "$mode" == "work" ]]; then
    icon=""
    [[ "$state" == "paused" ]] && icon=""
else
    icon=""
    [[ "$state" == "paused" ]] && icon=""
fi

printf "%s %02d:%02d\n" "$icon" "$minutes" "$seconds"
