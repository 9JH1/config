#!/bin/bash

# Read the current state from the temporary file
state=$(cat "$PWD/ws.tmp")

# Check if the second argument is "toggle"
if [[ $2 == "toggle" ]]; then
    if [[ "$state" == "windowed" ]]; then
        # Switch all windows to tiled mode (splitv)
        i3-msg layout splitv
        echo "managed" > "$PWD/ws.tmp"
        # Reset new windows to tiled mode (splith)
        echo "for_window [class=".*"] floating off" > ~/.config/i3/config
    elif [[ "$state" == "managed" ]]; then
        # Switch all windows to floating mode
        i3-msg floating enable
        echo "windowed" > "$PWD/ws.tmp"
        # Ensure new windows open as floating
        echo "for_window [class=".*"] floating enable" > ~/.config/i3/config
    else
        # Default to managed (tiled) if an unknown state is found
        i3-msg layout splitv
        echo "managed" > "$PWD/ws.tmp"
        # Ensure new windows open as tiled
        echo "for_window [class=".*"] floating off" > ~/.config/i3/config
    fi
fi

# Output the current state
echo "$state"

