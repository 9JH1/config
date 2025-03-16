import subprocess
import time
import pyautogui

# Function to capture the current screen
def capture_screen():
    screenshot = pyautogui.screenshot()
    screenshot.save('PRTSRC.jpeg')

# Function to move the window by a specific number of pixels
def move_window(fe_id, dx, dy, num_steps=110):
    for step in range(num_steps):
        x_pos = step * dx
        y_pos = step * dy
        subprocess.run(["wmctrl", "-i", "-r", fe_id, "-e", f"1,{x_pos},{y_pos},1920,1080"])
        time.sleep(0.01)  # Small delay to make the movement smoother

# Function to fetch the ID of the `feh` window
def get_feh_window_id():
    result = subprocess.run(["wmctrl", "-l"], capture_output=True, text=True)
    for line in result.stdout.splitlines():
        if "PRTSRC.jpeg" in line:
            return line.split()[0]
    return None

# Main function to handle workspace transition and movement
def transition_workspace(current_workspace, target_workspace):
    if current_workspace != target_workspace:
        # Take a screenshot
        capture_screen()

        # Open the screenshot using feh
        subprocess.run(["feh", "PRTSRC.jpeg", "&"])

        # Wait for feh to open
        time.sleep(0.2)

        # Get the window ID of feh
        feh_id = get_feh_window_id()

        if feh_id:
            # Slide the image window
            if target_workspace > current_workspace:
                move_window(feh_id, 1, 0)  # Move right
            else:
                move_window(feh_id, -1, 0)  # Move left

            # Wait and then kill the feh process
            time.sleep(0.5)
            subprocess.run(["pkill", "feh"])

# Example usage:
current_workspace = 3  # Assume you are on workspace 3
target_workspace = 4   # Assume you want to go to workspace 4

# Transition to the new workspace and move the screenshot
transition_workspace(current_workspace, target_workspace)

