#!/bin/bash

# ~/.local/bin/tmux-terminal.sh
# Toggle script that pulls tmux terminal from any workspace

SESSION_NAME="main"

# Check if there's already a kitty running tmux in any workspace
tmux_window=$(hyprctl clients -j | jq -r '.[] | select(.title | contains("'$SESSION_NAME'")) | .address' | head -1)

if [[ -n "$tmux_window" ]]; then
    # If exists, check if it's in the current workspace
    current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
    window_workspace=$(hyprctl clients -j | jq -r '.[] | select(.address == "'$tmux_window'") | .workspace.id')
    
    if [[ "$window_workspace" == "$current_workspace" ]]; then
        # If it's in current workspace, kill the process directly (no confirmation)
        window_pid=$(hyprctl clients -j | jq -r '.[] | select(.address == "'$tmux_window'") | .pid')
        kill $window_pid
    else
        # If it's in another workspace, pull it here
        hyprctl dispatch movetoworkspace $current_workspace,address:$tmux_window
        hyprctl dispatch focuswindow address:$tmux_window
    fi
else
    # If doesn't exist, create it
    # Ensure tmux session exists
    if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        tmux new-session -d -s "$SESSION_NAME"
    fi
    
    # Open kitty with no confirmation settings
    kitty -o confirm_os_window_close=0 tmux attach-session -t "$SESSION_NAME" &
fi
