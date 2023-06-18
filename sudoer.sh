#!/bin/bash

# Function to check if the command was successful
check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or with sudo privileges."
    exit 1
fi

# Get the current logged in username
current_user=$(logname 2>/dev/null)
check_success "Failed to get the current user."

# Check if the sudo group exists
getent group sudo >/dev/null 2>&1
check_success "The sudo group does not exist on this system."

# Add the user to the sudo group
usermod -aG sudo "$current_user" 2>/dev/null
check_success "Failed to add $current_user to the sudo group."

# Create a file in /etc/sudoers.d/ for the user
sudoers_file="/etc/sudoers.d/$current_user"
echo "$current_user ALL=(ALL) NOPASSWD: ALL" > "$sudoers_file"
check_success "Failed to add $current_user to the sudoers file."

# Set the correct permissions for the file
chmod 0440 "$sudoers_file" 2>/dev/null
check_success "Failed to set permissions on the sudoers file for $current_user."

echo "The user $current_user has been added as a sudo user and can now run sudo without a password."
