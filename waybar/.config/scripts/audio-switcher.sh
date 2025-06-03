#!/bin/bash

# Audio output switcher script via wofi
# Save as ~/.config/scripts/audio-switcher.sh
# Optimized for PipeWire with enhanced UX

set -euo pipefail  # Strict error handling

# Function to create optimal wofi configuration
create_wofi_config() {
    local temp_config
    temp_config=$(mktemp --suffix=.wofi)
    cat > "$temp_config" << 'EOF'
width=420
height=180
location=center
show=dmenu
prompt=🎵 Audio
filter_rate=100
allow_markup=true
no_actions=true
hide_search=true
insensitive=true
gtk_dark=true
key_expand=Tab
orientation=vertical
content_halign=fill
lines=5
columns=1
EOF
    echo "$temp_config"
}

# Function to get audio sink information with enhanced parsing
get_audio_sinks() {
    wpctl status 2>/dev/null | awk '
        /├─ Sinks:/,/├─ Sources:/ {
            if (/^\s*│\s*\*?\s*[0-9]+\./) {
                print $0
            }
        }
    ' | grep -v "HDMI\|Monitor" || true
}

# Function to clean and format device names
format_device_name() {
    local name="$1"
    
    # Apply smart name replacements for better readability
    name=$(echo "$name" | sed -E '
        s/Raptor Lake High Definition Audio Controller/Built-in/g
        s/GA107 High Definition Audio Controller/NVIDIA/g
        s/High Definition Audio Controller/Audio/g
        s/Digital Stereo \([^)]*\)/Digital/g
        s/Analog Stereo/Analog/g
        s/\s+/ /g
    ')
    
    # Trim whitespace
    name=$(echo "$name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    echo "$name"
}

# Function to show menu and switch output
show_menu() {
    local wofi_config sink_lines formatted_outputs selected device_name device_id
    
    # Create temporary wofi config
    wofi_config=$(create_wofi_config)
    
    # Get sink information
    sink_lines=$(get_audio_sinks)
    
    if [[ -z "$sink_lines" ]]; then
        notify-send "🎵 Audio Switcher" "No compatible audio outputs found" \
            --icon=audio-speakers --urgency=normal --expire-time=3000
        rm -f "$wofi_config"
        exit 1
    fi
    
    # Build formatted output list
    formatted_outputs=""
    
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        
        # Extract device ID (first number after │)
        local id
        id=$(echo "$line" | grep -o '[0-9]\+' | head -1)
        
        # Extract and clean device name
        local raw_name clean_name
        raw_name=$(echo "$line" | sed -E 's/^[^0-9]*[0-9]+\.\s*//' | sed 's/\s*\[vol:.*$//')
        clean_name=$(format_device_name "$raw_name")
        
        # Skip invalid names
        [[ -z "$clean_name" || "$clean_name" =~ ^[0-9.]+$ ]] && continue
        
        # Format entry with appropriate icon and styling
        if echo "$line" | grep -q "\*"; then
            formatted_outputs+="<span color='#a6e3a1'>🔊</span> <b>$clean_name</b> <span color='#94e2d5'>(active)</span>\n"
        else
            formatted_outputs+="<span color='#6c7086'>🔇</span> $clean_name\n"
        fi
    done <<< "$sink_lines"
    
    # Show wofi menu with enhanced styling
    selected=$(echo -e "$formatted_outputs" | wofi \
        --style ~/.config/wofi/style.css \
        --conf "$wofi_config" \
        --dmenu \
        --cache-file /dev/null 2>/dev/null) || true
    
    # Cleanup
    rm -f "$wofi_config"
    
    [[ -z "$selected" ]] && exit 0
    
    # Extract device name from selection (remove markup and status)
    device_name=$(echo "$selected" | sed -E 's/<[^>]*>//g' | sed -E 's/^[🔊🔇]\s*//' | sed -E 's/\s*\(active\)$//')
    
    # Find corresponding device ID
    device_id=$(echo "$sink_lines" | grep -F "$device_name" | grep -o '[0-9]\+' | head -1)
    
    if [[ -n "$device_id" ]]; then
        # Switch to selected device
        if wpctl set-default "$device_id" 2>/dev/null; then
            notify-send "🎵 Audio Output" "Switched to: $device_name" \
                --icon=audio-speakers --urgency=low --expire-time=2000
        else
            notify-send "🎵 Audio Switcher" "Failed to switch audio output" \
                --icon=dialog-error --urgency=normal --expire-time=3000
        fi
    else
        notify-send "🎵 Audio Switcher" "Device not found: $device_name" \
            --icon=dialog-error --urgency=normal --expire-time=3000
    fi
}

# Function to toggle between available outputs (smart toggle)
quick_toggle() {
    local sink_lines outputs current next_index next_output output_name
    
    # Get non-HDMI sink IDs
    sink_lines=$(get_audio_sinks)
    readarray -t outputs < <(echo "$sink_lines" | grep -o '[0-9]\+')
    
    # If less than 2 devices, show menu instead
    if (( ${#outputs[@]} < 2 )); then
        show_menu
        return
    fi
    
    # Get current output ID
    current=$(echo "$sink_lines" | grep "\*" | grep -o '[0-9]\+' | head -1)
    
    # Find next output in rotation
    for i in "${!outputs[@]}"; do
        if [[ "${outputs[$i]}" == "$current" ]]; then
            next_index=$(( (i + 1) % ${#outputs[@]} ))
            next_output=${outputs[$next_index]}
            
            # Switch to next output
            if wpctl set-default "$next_output" 2>/dev/null; then
                # Get clean name of new output
                output_name=$(echo "$sink_lines" | grep -E "^\s*│\s*\*?\s*${next_output}\." | \
                    sed -E 's/^[^0-9]*[0-9]+\.\s*//' | sed 's/\s*\[vol:.*$//')
                output_name=$(format_device_name "$output_name")
                
                notify-send "🎵 Audio Output" "Switched to: $output_name" \
                    --icon=audio-speakers --urgency=low --expire-time=2000
            else
                notify-send "🎵 Audio Switcher" "Failed to switch audio output" \
                    --icon=dialog-error --urgency=normal --expire-time=3000
            fi
            return
        fi
    done
    
    # Fallback: show menu if current device not found
    show_menu
}

# Main execution with argument handling
main() {
    case "${1:-toggle}" in
        "menu"|"m")
            show_menu
            ;;
        "toggle"|"t"|"")
            quick_toggle
            ;;
        "help"|"h"|"--help")
            cat << 'EOF'
Audio Output Switcher

Usage: audio-switcher.sh [COMMAND]

Commands:
  toggle, t     Toggle between available outputs (default)
  menu, m       Show selection menu
  help, h       Show this help

Examples:
  audio-switcher.sh          # Quick toggle
  audio-switcher.sh toggle   # Quick toggle
  audio-switcher.sh menu     # Show menu
EOF
            ;;
        *)
            echo "Unknown command: $1" >&2
            echo "Use 'audio-switcher.sh help' for usage information" >&2
            exit 1
            ;;
    esac
}

# Execute main function with all arguments
main "$@"
