#!/bin/bash

# Alterna entre sinks de audio (speakers / bluetooth) via wpctl (PipeWire)
# Clique esquerdo: troca o sink padrao
# Sem argumento: mostra o sink ativo

SINKS_BLOCK=$(wpctl status | sed -n '/Sinks:/,/Sink endpoints:/p')

get_default_sink_id() {
    echo "$SINKS_BLOCK" | grep '\*' | head -1 | grep -oP '\d+\.' | head -1 | tr -d '.'
}

get_default_sink_name() {
    echo "$SINKS_BLOCK" | grep '\*' | head -1
}

get_icon() {
    local sink_info="$1"
    if echo "$sink_info" | grep -qi "blue"; then
        echo "󰂯"
    else
        echo "󰓃"
    fi
}

get_sink_ids() {
    echo "$SINKS_BLOCK" | grep -oP '^\s*│?\s*\*?\s*\K\d+(?=\.)'
}

switch_sink() {
    local current
    current=$(get_default_sink_id)

    mapfile -t sinks < <(get_sink_ids)

    if [[ ${#sinks[@]} -lt 2 ]]; then
        return
    fi

    # round-robin pro proximo sink
    local next="${sinks[0]}"
    for i in "${!sinks[@]}"; do
        if [[ "${sinks[$i]}" == "$current" ]]; then
            local next_idx=$(( (i + 1) % ${#sinks[@]} ))
            next="${sinks[$next_idx]}"
            break
        fi
    done

    wpctl set-default "$next"
}

case "${1:-}" in
    switch)
        switch_sink
        ;;
    *)
        icon=$(get_icon "$(get_default_sink_name)")
        echo "%{T2}${icon}%{T-}"
        ;;
esac
