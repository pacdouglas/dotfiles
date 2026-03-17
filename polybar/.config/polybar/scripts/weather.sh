#!/usr/bin/env bash

# Weather via Open-Meteo (free, sem API key)
# Coordenadas de Sao Paulo (-23.55, -46.63)
# Troque lat/lon pra sua cidade
LAT="-23.55"
LON="-46.63"

cache_file="/tmp/polybar-weather"
cache_ttl=1800  # 30 minutos

# Usa cache pra nao spammar requests
if [[ -f "$cache_file" ]]; then
    age=$(( $(date +%s) - $(stat -c %Y "$cache_file") ))
    if (( age < cache_ttl )); then
        cat "$cache_file"
        exit 0
    fi
fi

url="https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current=temperature_2m,weather_code&timezone=auto"
response=$(curl -sf --max-time 5 "$url" 2>/dev/null)

if [[ -z "$response" ]]; then
    [[ -f "$cache_file" ]] && cat "$cache_file" || echo ""
    exit 0
fi

# Extrai valores com sed (evita conflito com alias grep->rg)
temp=$(echo "$response" | sed -n 's/.*"temperature_2m":\([0-9.-]*\).*/\1/p')
code=$(echo "$response" | sed -n 's/.*"weather_code":\([0-9]*\).*/\1/p')

# WMO weather code -> icone
case "$code" in
    0)          icon="" ;;      # ceu limpo
    1|2|3)      icon="" ;;      # parcialmente nublado
    45|48)      icon="" ;;      # nevoeiro
    51|53|55)   icon="" ;;      # chuvisco
    61|63|65)   icon="" ;;      # chuva
    71|73|75)   icon="" ;;      # neve
    80|81|82)   icon="" ;;      # pancadas
    95|96|99)   icon="" ;;      # tempestade
    *)          icon="" ;;
esac

temp_int=${temp%.*}
result="$icon ${temp_int}°C"

echo "$result" > "$cache_file"
echo "$result"
