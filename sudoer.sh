#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or with sudo privileges."
    exit
fi
# Get the current logged in username
current_user=$(logname)

# Add the user to the sudo group
usermod -aG sudo $current_user

# Add the user to the sudoers file to run sudo without a password
echo "$current_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$current_user

# Set the correct permissions for the file
chmod 0440 /etc/sudoers.d/$current_user

echo "The user $current_user has been added as a sudo user and can now run sudo without a password."
