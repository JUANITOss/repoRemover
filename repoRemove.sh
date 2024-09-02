#!/bin/bash

# Function to check if send2trash is installed
check_send2trash_installed() {
    python3 -c "import send2trash" 2>/dev/null
}

# Function to install send2trash if not installed
install_send2trash() {
    echo "send2trash module not found. Installing..."
    sudo apt update
    sudo apt install -y python3-send2trash
}

# Check if send2trash is installed, install if necessary
if ! check_send2trash_installed; then
    install_send2trash
fi

# Define folder names to check, I think the most common ones are these
FOLDERS=("workspace" "Workspace" "repos" "Repos")

# Find the first existing folder
TARGET_FOLDER=""
for FOLDER in "${FOLDERS[@]}"; do
    if [ -d "$HOME/$FOLDER" ]; then
        TARGET_FOLDER="$HOME/$FOLDER"
        break
    fi
done

# If no folder found, use the first one and create it
if [ -z "$TARGET_FOLDER" ]; then
    TARGET_FOLDER="$HOME/${FOLDERS[0]}"
    mkdir -p "$TARGET_FOLDER"
fi

# Create the Python script file in the target folder
PYTHON_SCRIPT="$TARGET_FOLDER/repoRemover.py"
cat <<EOF > "$PYTHON_SCRIPT"
#!/usr/bin/env python3
import os
from send2trash import send2trash

# Change to YOUR OWN folder, mine is named "Workspace"
os.chdir(os.path.expanduser("~/Workspace"))

# List directories only, numbered
directories = [d for d in os.listdir() if os.path.isdir(d)]
for i, dir_name in enumerate(directories, start=1):
    print(f"{i}. {dir_name}")

# Ask the user to choose a directory by number
try:
    choice = int(input("Enter the number of the directory you want to send to the trash: "))
    if choice < 1 or choice > len(directories):
        print("Invalid choice. Exiting.")
        exit(1)
except ValueError:
    print("Please enter a valid number.")
    exit(1)

# Get the directory name based on the choice
dir_to_delete = directories[choice - 1]

# Ask for confirmation
confirmation = input(f"Are you sure you want to send '{dir_to_delete}' to the trash? Type 'yes' to confirm: ")

if confirmation.lower() == 'yes':
    # Send the directory to the trash
    send2trash(dir_to_delete)
    print(f"Directory '{dir_to_delete}' has been moved to the trash.")
else:
    print("Operation cancelled.")
EOF

# Make the Python script executable
chmod +x "$PYTHON_SCRIPT"
