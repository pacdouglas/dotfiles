#!/bin/bash

# ~/.local/bin/tmux-terminal.sh
# Toggle script that pulls tmux terminal from any workspace and remembers position/size

SESSION_NAME="main-kitty-tmux-pac"
GEOMETRY_FILE="/tmp/tmux-terminal-geometry"

# Function to save window geometry
save_geometry() {
    local window_address="$1"
    if [[ -n "$window_address" ]]; then
        # Get window geometry from hyprctl
        local geometry=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$window_address\") | \"\(.at[0]),\(.at[1]),\(.size[0]),\(.size[1])\"")
        if [[ "$geometry" != "null" ]] && [[ -n "$geometry" ]]; then
            echo "$geometry" > "$GEOMETRY_FILE"
        fi
    fi
}

# Function to restore window geometry
restore_geometry() {
    local window_address="$1"
    if [[ -f "$GEOMETRY_FILE" ]] && [[ -n "$window_address" ]]; then
        local saved_geometry=$(cat "$GEOMETRY_FILE")
        if [[ -n "$saved_geometry" ]]; then
            IFS=',' read -r x y width height <<< "$saved_geometry"

            # Restore position and size
            hyprctl dispatch movewindowpixel exact $x $y,address:$window_address
            hyprctl dispatch resizewindowpixel exact $width $height,address:$window_address
        fi
    fi
}

# Check if there's already a kitty running tmux in any workspace
tmux_window=$(hyprctl clients -j | jq -r '.[] | select(.title | contains("'$SESSION_NAME'")) | .address' | head -1)

if [[ -n "$tmux_window" ]]; then
    # If exists, check if it's in the current workspace
    current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
    window_workspace=$(hyprctl clients -j | jq -r '.[] | select(.address == "'$tmux_window'") | .workspace.id')

    if [[ "$window_workspace" == "$current_workspace" ]]; then
        # If it's in current workspace, save geometry and close
        save_geometry "$tmux_window"
        window_pid=$(hyprctl clients -j | jq -r '.[] | select(.address == "'$tmux_window'") | .pid')
        kill $window_pid
    else
        # If it's in another workspace, pull it here and restore geometry
        hyprctl dispatch movetoworkspace $current_workspace,address:$tmux_window
        hyprctl dispatch focuswindow address:$tmux_window

        # Small delay to ensure window is moved before restoring geometry
        sleep 0.1
        restore_geometry "$tmux_window"
    fi
else
    # If doesn't exist, create it
    # Ensure tmux session exists
    if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        tmux new-session -d -s "$SESSION_NAME"
    fi

    # Open kitty connecting to tmux session
    kitty -o confirm_os_window_close=0 tmux attach-session -t "$SESSION_NAME" &

    # Wait for window to appear and then restore geometry
    sleep 0.3

    # Find the new window and restore its geometry
    new_window=$(hyprctl clients -j | jq -r '.[] | select(.title | contains("'$SESSION_NAME'")) | .address' | head -1)
    if [[ -n "$new_window" ]]; then
        restore_geometry "$new_window"
    fi
fi
