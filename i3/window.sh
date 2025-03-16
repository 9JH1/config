#!/bin/bash

# Function to capture the screen using scrot
capture_screen() {
    scrot -q 50 PRTSRC.jpeg
}

# Function to move the window left
move_window_left() {
    FEH_ID=$(wmctrl -l | grep "PRTSRC.jpeg" | awk '{print $1}')
    wmctrl -i -r $FEH_ID -b add,above  # Ensure the window is on top
    for (( c=0; c<screen_width; c+=10 )); do
        wmctrl -i -r $FEH_ID -e 1,$((c)),0,$screen_width,$screen_height
        sleep 0.01
    done
}

# Function to move the window right
move_window_right() {
    FEH_ID=$(wmctrl -l | grep "PRTSRC.jpeg" | awk '{print $1}')
    wmctrl -i -r $FEH_ID -b add,above  # Ensure the window is on top
    for (( c=0; c<screen_width; c+=10 )); do
        wmctrl -i -r $FEH_ID -e 1,$((screen_width-c)),0,$screen_width,$screen_height
        sleep 0.01
    done
}

# Get screen resolution (width x height)
screen_resolution=$(xrandr | grep '*' | awk '{print $1}')
screen_width=$(echo $screen_resolution | cut -d 'x' -f 1)
screen_height=$(echo $screen_resolution | cut -d 'x' -f 2)

# Get the current workspace
CURRENT_WORKSPACE=$(xprop -root -notype _NET_CURRENT_DESKTOP | sed 's/.* = //' | awk '{print $1}')

# Target workspace is passed as an argument
TARGET_WORKSPACE=$1

# Check if the current workspace is not the target workspace
if [ "$CURRENT_WORKSPACE" -ne "$TARGET_WORKSPACE" ]; then
    # Capture the screenshot
    capture_screen

    # Open the screenshot using feh
    feh PRTSRC.jpeg &

    # Wait for feh to open
    sleep 0.2

    # Ensure the window is focused and on top
    FEH_ID=$(wmctrl -l | grep "PRTSRC.jpeg" | awk '{print $1}')
    wmctrl -i -r $FEH_ID -b add,above  # Make sure feh is on top

    # Move the window based on the workspace transition
    if [ "$TARGET_WORKSPACE" -gt "$CURRENT_WORKSPACE" ]; then
        move_window_right
    else
        move_window_left
    fi

    # Wait a bit and then kill the feh process
    sleep 0.5
    pkill feh
fi

