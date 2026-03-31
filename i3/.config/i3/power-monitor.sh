#!/usr/bin/env bash

# Monitora estado da energia (tomada vs bateria) e troca config do picom
# - Na tomada: picom completo (blur, sombras, rounded corners)
# - Na bateria: picom leve (sem efeitos pesados)

PICOM_FULL="$HOME/.config/picom/picom.conf"
PICOM_BATTERY="$HOME/.config/picom/picom-battery.conf"
STATE_FILE="/tmp/power-monitor-state"
CHECK_INTERVAL=15

get_power_state() {
    # Checa se ta na tomada
    for supply in /sys/class/power_supply/AC* /sys/class/power_supply/ADP*; do
        if [[ -f "$supply/online" ]]; then
            cat "$supply/online"
            return
        fi
    done
    # Fallback: se nao achou adaptador, assume tomada
    echo "1"
}

swap_picom() {
    local config="$1"
    killall -q picom
    sleep 0.3
    picom --config "$config" -b
}

# Estado inicial desconhecido pra forcar a primeira troca
echo "unknown" > "$STATE_FILE"

while true; do
    ac_online=$(get_power_state)
    prev_state=$(cat "$STATE_FILE" 2>/dev/null)

    if [[ "$ac_online" == "1" && "$prev_state" != "ac" ]]; then
        swap_picom "$PICOM_FULL"
        echo "ac" > "$STATE_FILE"
        notify-send "Energia" "Na tomada — efeitos visuais ativados" -u low -t 3000

    elif [[ "$ac_online" == "0" && "$prev_state" != "battery" ]]; then
        swap_picom "$PICOM_BATTERY"
        echo "battery" > "$STATE_FILE"
        notify-send "Energia" "Na bateria — modo leve ativado" -u low -t 3000
    fi

    sleep "$CHECK_INTERVAL"
done
